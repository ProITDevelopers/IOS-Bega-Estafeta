//
//  MapController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/7/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import StompClientLib
import SwiftyJSON
import UserNotifications
import MBProgressHUD
import PopMenu
import KeychainSwift //1º declara isso


class MapController: UIViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    private var direcoesRotas: Route?
    
    
    private lazy var mensagemBanner = MensagemBanner()
    private lazy var annotation = MGLPointAnnotation()
    private lazy var apiService = APIService()
    private lazy var bannners = MensagemBanner()
    private lazy var keychain = KeychainSwift() //2º declara isso
    
    
    
    var coordenadaDestino = CLLocationCoordinate2D(latitude:  -8.827515/*-8.827554*/, longitude: 13.228986 /*13.229368*/)
    
    private lazy var socketClient = StompClientLib()
    private var url = URL(string: "https://motoboy.begaentrega.com/api-entrega/websocket")
    
    var mensagem = ""
    var firstTime = true
    
    // 3º depois isso
    private var authorization: [String:String] {
        if let token = self.keychain.get(Keys.token) {
            return [
                "X-Authorization" : token,
                "heart-beat" : "0,10000"
            
            ]
        }
        return [:]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configuracaoNotification()
        setupMapView()
        abrirConexaoSocket()
        
        // removerNoMapa()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstTime ==  false {
            self.bannners.MensagemErro(mensagem)
        }
        
    }
    
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //    }
    
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //        socketClient.disconnect()
    //    }
    
    
    
    @IBAction func BotaoNavegar(_ sender: UIButton) {
        // mostrarRotaNoMapa()
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    }
    
    
    @IBAction func VerEncomendas(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "teste", sender: self)
    }
    
    
    @IBAction func MoreButton(_ sender: UIBarButtonItem) {
        apiService.presentMenu(sender, self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teste" {
            if let vc = segue.destination as? EncomendasController {
                vc.coordenadasDelegate = self
            }
            
        }
    }
    
    
    
    
    
    //padroes do mapa
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true // mostra localizacao atual
        mapView.userLocation?.title = "Tu estas aqui"
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil) // segue o usuario
        // mapView.styleURL = MGLStyle.darkStyleURL // fundo escuro
        
    }
    
    
    //abrir conexao no socket
    private func abrirConexaoSocket() {
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url!), delegate: self, connectionHeaders: authorization)
    }
    
    
    
    //apaga todas as anotações do mapa anterior
    private func removerNoMapa() {
        //APAGA TUDO QUE ESTAVA NO MAPA ANTERIORMENTE
        guard let annotation = self.mapView.annotations else {return}
        guard let source = self.mapView.style?.source(withIdentifier: "route-source") else {return}
        guard let lineStyle = self.mapView.style?.layer(withIdentifier: "route-style") else {return}
        self.mapView.removeAnnotations(annotation)
        self.mapView.style?.removeSource(source)
        self.mapView.style?.removeLayer(lineStyle)
    }
    
    
    
    private func mostrarRotaNoMapa(){
        mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
        annotationCustom()
        calcularRota(origemCoordenadas: (mapView.userLocation!.coordinate), destinoCoordenadas: coordenadaDestino) { (route, error) in
            if error != nil {
                print("ERROR")
            }
        }
    }
    
    
    
    private func configuracaoNotification(){
        //NOTIFICACOES
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                // Handle Error
        })
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    
    
    private func annotationCustom() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordenadaDestino
        annotation.title = "Destino"
        mapView.addAnnotation(annotation)
    }
    
    
    
    
    
    
    private func calcularRota(origemCoordenadas: CLLocationCoordinate2D, destinoCoordenadas: CLLocationCoordinate2D, completion: @escaping (Route?, Error?) -> ()) {
        
        //Pegar coordenadas do estafeta e do destino
        let origem = Waypoint(coordinate: origemCoordenadas, coordinateAccuracy: -1, name: "Você")
        let destino = Waypoint(coordinate: destinoCoordenadas, coordinateAccuracy: -1, name: "Destino")
        
        // mostra o melhor caminho sem engarrafamento
        let opcoes = NavigationRouteOptions(waypoints: [origem, destino], profileIdentifier: .automobileAvoidingTraffic)
        opcoes.locale = .init(identifier: "pt_PT")
        //calcular rota
        _ = Directions.shared.calculate(opcoes, completionHandler: { (waypoints, routes, error) in
            self.direcoesRotas = routes?.first // pega a primeira rota
            guard let direcoesRotas =  self.direcoesRotas else {return}
            self.desenharRota(route: direcoesRotas)
            
            
            let coordinateBounds = MGLCoordinateBounds(sw: destinoCoordenadas, ne: origemCoordenadas)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
            
        })
    }
    
    
    
    
    
    
    private func desenharRota(route: Route) {
        
        guard route.coordinateCount > 0 else { return }
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 4)
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
        
        
    }
    
    
    
    
}










//MARK: MapBox METHODS

extension MapController: MGLMapViewDelegate, NavigationViewControllerDelegate {
    
    
    
    // mostra os dados quando clica no ponto
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    
    // mostra o mapa para direcionar o caminho
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigacao = NavigationViewController(for: direcoesRotas!)
        navigacao.delegate = self
        navigacao.automaticallyAdjustsStyleForTimeOfDay = true
        present(navigacao, animated: true, completion: nil)
    }
    
    
    //  vai atualizando as coordenadas do estafeta em andamento no navgationcontroller
    func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        
        //ENVIA OS DADOS PARA O WEBSOCKET
        let dict: [String: Any] = [
            "latitude": String(location.coordinate.latitude),
            "longitude": String(location.coordinate.longitude)
        ]
        socketClient.sendJSONForDict(dict: dict as AnyObject, toDestination: "/app/tempo/real/estafeta")
        
        
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {
        mensagemBanner.MensagemErro(error.localizedDescription)
    }
    func mapView(_ mapView: MGLMapView, didFailToLocateUserWithError error: Error) {
        mensagemBanner.MensagemErro(error.localizedDescription)
    }
    
    
    
    
    //quando o estafeta chega ao destino
    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
        mensagemBanner.MensagemNoMapa("Chegou ao seu Destino")
        return false
    }
    
    
    
    //quando o user clica no sair
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        dismiss(animated: true, completion: nil)
        self.viewDidLoad()
    }
    
    
    
    
    
}









//MARK: STOMP METHODS


extension MapController: StompClientLibDelegate {
    
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        guard let jsonBody = jsonBody else {return print("json vazio")}
        let json = JSON(jsonBody)
       // print(json)
        guard let mensagem = json["mensagem"].string else {return print("body vazio")}
        guard let subtitle = json["dataHora"].string else {return print("subtitulo vazio")}
        mostrarNotificacao(mensagem, subtitle)
    }
    
    
    
    
    
    
    //CONNECT
    func stompClientDidConnect(client: StompClientLib!) {
        socketClient.subscribe(destination: "/user/topic/notificacoes")
    }
    
    
    
    func stompClientDidDisconnect(client: StompClientLib!) {
       // abrirConexaoSocket()
    }
    
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {}
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        bannners.MensagemErro("Stomp: \(description.uppercased())!")
    }
    func serverDidSendPing() {}
    
    
    
}









extension MapController: UNUserNotificationCenterDelegate {
    
    func mostrarNotificacao(_ title: String, _ subtitile: String, _ body: String?=nil){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitile
        content.body = body ?? ""
        content.badge = 0
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        
        let requestIdentifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                // Handle error
        })
    }
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        let userInfo = response.notification.request.content
        //background
        if(application.applicationState == .active){
            print(userInfo.title)
            print(userInfo.subtitle)
            print(userInfo.body)
        }
        
        
        //foreground
        if(application.applicationState == .inactive)
        {
            print(userInfo.title)
            print(userInfo.subtitle)
            print(userInfo.body)
        }
        
        
        
        completionHandler()
    }
}








//MARK: Delegate Coordenadas das Encomendas
extension MapController: CoordenadasEncomendasDelegate {
    
    func atualizarCoordenadas(_ NovasCoordenadas: CLLocationCoordinate2D) {
        if CLLocationCoordinate2DIsValid(NovasCoordenadas) {
            coordenadaDestino = NovasCoordenadas
            mostrarRotaNoMapa()
        } else {
            self.mensagem = "Coordenadas Inválidas!"
            firstTime = false
        }

    }
    
}





//MARK: Delegate popMenuViewController

extension MapController: PopMenuViewControllerDelegate {
    
    // This will be called when a menu action was selected
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        switch index {
        case 0:
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                guard let selfView = self else {return}
                selfView.performSegue(withIdentifier: "def", sender: selfView)
            }
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                guard let selfView = self else {return}
                selfView.apiService.sairDaSessão(selfView.bannners, selfView)
            }
        default:
            return
        }
    }
    
}

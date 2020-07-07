//
//  EncomendasController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/28/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import Mapbox
import SwiftMessages




class EncomendasController: UIViewController {
    
    
    private let urlEspera = "http://52.14.171.89:8085/api/encomendas/espera/estafeta"
    private let urlAndamento = "http://52.14.171.89:8085/api/encomendas/andamento/estafeta"
    private let urlEntregue = "http://52.14.171.89:8085/api/encomendas/estafeta"
    public lazy var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var estadosControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var coordenadasDelegate: CoordenadasEncomendasDelegate?
    
    
    private lazy var estado = "ESPERA"
    private lazy var url = "http://52.14.171.89:8085/api/encomendas/espera/estafeta"
    private lazy var banner = MensagemBanner()
    private lazy var apiRequest = APIService()
    
    private var listaModel = [ListaModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
            
        }
    }
    
    private var errors: String? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                if let erro = self?.errors {
                    self?.refreshControl.endRefreshing()
                    self?.banner.MensagemErro(erro)
                }
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarRefresh()
        apiRequest.delegate = self
        apiRequest.performRequest(urlEspera)
        tableView.register(UINib.init(nibName: "EncomendasCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftMessages.hideAll()
    }
    
    
    
    @IBAction func ListaDeEncomendasSegementedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            SwiftMessages.hideAll()
            url = urlEspera
            apiRequest.performRequest(urlEspera)
            estado = "ESPERA"
            
        case 1:
            SwiftMessages.hideAll()
            url = urlAndamento
            apiRequest.performRequest(urlAndamento)
            estado = "ANDAMENTO"
            
        case 2:
            SwiftMessages.hideAll()
            url = urlEntregue
            apiRequest.performRequest(urlEntregue)
            estado = "ENTREGUE"
        default:
            return
        }
    }
    
    
    //MARK: Mostrar refresh
    public func mostrarRefresh() {
        // 1º verificar a versão do IOS
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configurar Refresh Control
        refreshControl.addTarget(self, action: #selector(self.performRequest), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Buscando...", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 0.3431279063, blue: 0, alpha: 1)])
        refreshControl.tintColor = #colorLiteral(red: 1, green: 0.3431279063, blue: 0, alpha: 1)

    }
    
    
    @objc private func performRequest(){
        apiRequest.performRequest(url)
    }

    
    
    
    
}







//MARK: Delegate TableView
extension EncomendasController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = listaModel.count > 0 ? listaModel.count : 0
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EncomendasCell
        cell.dadosLista = listaModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        apiRequest.popDadosDoCliente(indexPath,estado,banner,self,coordenadasDelegate,listaModel)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(listaModel.count) pedidos no total."
    }

    
}


protocol CoordenadasEncomendasDelegate {
    func atualizarCoordenadas(_ NovasCoordenadas: CLLocationCoordinate2D)
}








//MARK: Delegate ListaEncomendas

extension EncomendasController: ListaEncomendasDelegate {
    func didStartRefreshing() {
        
    }
    
    func responseSucess() {
       // self.refreshControl.beginRefreshing()
        DispatchQueue.main.async { [weak self] in
            //self?.refreshControl.endRefreshing()
            self?.banner.MensagemSucess()
        
        }
    }
    
    func responseFailed(_ erroMessage: String) {
        errors = erroMessage
        
    }
    
    func didFailWithError(_ error: Error) {
        errors = error.localizedDescription
    }
    
    func didUpdateListaEncomendas(_ apiService: APIService, _ listaEncomenda: [ListaModel]) {
        listaModel = listaEncomenda
    }
    
}



//MARK: Delegate BannerMessage
extension EncomendasController: BannerDelegate {
    
    func confirmarEntregaCliente(_ pagamento: String, _ idEncomenda: String, _ json: [String : Any]) {
        switch pagamento {
        case "WALLET":
            apiRequest.performPUTrequest("http://52.14.171.89:8085/api/encomenda/\(idEncomenda)/pagamento/wallet/estafeta", nil, json)
        case "TPA":
            apiRequest.performPUTrequest("http://52.14.171.89:8085/api/encomenda/\(idEncomenda)/pagamento/tpa/estafeta", nil, json)
        default:
            return
        }
    }
    
    
    
    
    func botaoConfirmar(_ idEncomenda: Int?) {
        guard let idEncomenda = idEncomenda else {return}
        apiRequest.performPUTrequest("http://52.14.171.89:8085/api/encomenda/andamento/estafeta", [["id" : idEncomenda]])
    }
    
    func mostrarRota() {
        navigationController?.popToRootViewController(animated: true)
    }
}




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
    
    
    private let urlEspera = "http://35.181.153.234:8085/api/encomendas/espera/estafeta"
    private let urlAndamento = "http://35.181.153.234:8085/api/encomendas/andamento/estafeta"
    private let urlEntregue = "http://35.181.153.234:8085/api/encomendas/estafeta"
    
    
    @IBOutlet weak var estadosControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var coordenadasDelegate: CoordenadasEncomendasDelegate?
    
    
    private var estado = "ESPERA"
    private lazy var banner = MensagemBanner()
    private lazy var apiRequest = APIService()
    private var listaModel = [ListaModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }
    
    private var errors: String? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                if let erro = self?.errors {
                    self?.banner.MensagemErro(erro)
                }
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            apiRequest.performRequest(urlEspera)
            estado = "ESPERA"
            
        case 1:
            SwiftMessages.hideAll()
            apiRequest.performRequest(urlAndamento)
            estado = "ANDAMENTO"
        case 2:
            SwiftMessages.hideAll()
            apiRequest.performRequest(urlEntregue)
            estado = "ENTREGUE"
        default:
            return
        }
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
    func responseSucess() {
        DispatchQueue.main.async { [weak self] in
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
            apiRequest.performPUTrequest("http://35.181.153.234:8085/api/encomenda/\(idEncomenda)/pagamento/wallet/estafeta", nil, json)
        case "TPA":
            apiRequest.performPUTrequest("http://35.181.153.234:8085/api/encomenda/\(idEncomenda)/pagamento/tpa/estafeta", nil, json)
        default:
            return
        }
    }
    
    
    
    
    func botaoConfirmar(_ idEncomenda: Int?) {
        guard let idEncomenda = idEncomenda else {return}
        apiRequest.performPUTrequest("http://35.181.153.234:8085/api/encomenda/andamento/estafeta", [["id" : idEncomenda]])
    }
    
    func mostrarRota() {
        navigationController?.popToRootViewController(animated: true)
    }
}




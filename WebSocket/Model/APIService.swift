//
//  APIService.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/22/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import Foundation
import SwiftyJSON
import Mapbox
import KeychainSwift
import MBProgressHUD
import PopMenu


struct APIService {
    
    
    public var delegate: ListaEncomendasDelegate?
    public var dataSourcePerfil: PerfilDataSource?
    private var coord: CLLocationCoordinate2D?
    private var banners = MensagemBanner()
    private let keychain = KeychainSwift()
   
    
    //GET METHOD
    func performRequest(_ url: String, _ controller: EncomendasController?=nil) {
        controller?.refreshControl.beginRefreshing()
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string: url) , let token = self.keychain.get(Keys.token)  {
                let session = URLSession(configuration: .default)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                let task = session.dataTask(with: urlRequest) { (data, response, error) in
                    if error != nil {
                        guard let error = error else {return}
                        self.delegate?.didFailWithError(error)
                        return
                    }
                    if let safeData = data {
                        if let listaEncomendas = self.passJSON(data: safeData) {
                            self.delegate?.didUpdateListaEncomendas(self, listaEncomendas)
                        }
                    }
                    
                }
                task.resume()
            }
        }
        
    }
    
    
    
    //PARSE JSON
    func passJSON(data: Data) -> [ListaModel]? {
        
        //        do{
        //            let json: JSON = try JSON(data: data)
        //            print(json)
        //        }catch{
        //            print(error.localizedDescription)
        //        }
        
        let decoder = JSONDecoder()
        var listaEncomendasArray = [ListaModel]()
        
        do {
            let decodedData = try decoder.decode([ListaData].self, from: data)
            if decodedData.isEmpty == false {
                for i in decodedData {
                    let model = ListaModel(nomeCliente: i.nomeCliente, nomeLoja: i.nomeLoja, telefoneCliente: i.telefoneCliente, dataCriacao: i.dataCriacao, estadoEncomenda: i.estadoEncomenda, latitudeOrigem: i.latitudeOrigem, longitudeOrigem: i.longitudeOrigem, tipoPagamento: i.tipoPagamento, valor: i.valor, idFatura: i.idFatura, id: i.id, longitudeDestino: i.longitudeDestino, latitudeDestino: i.latitudeDestino)
                    listaEncomendasArray.append(model)
                }
            } else {
                self.delegate?.responseFailed("Sem ecomendas")
            }
            
            return listaEncomendasArray
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //PUT METHOD
    func performPUTrequest(_ url: String, _ json: [[String:Any]]?=nil, _ jsonDict: [String:Any]?=nil) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string: url), let token = self.keychain.get(Keys.token)  {
                let session = URLSession(configuration: .default)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "PUT"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: json ?? jsonDict ?? "", options: [])
                    let task = session.uploadTask(with: urlRequest, from: jsonData) { (data, response, error) in
                        if error != nil {
                            guard let error = error else {return}
                            self.delegate?.didFailWithError(error)
                            return
                        }
                        
                        guard let responses = response as? HTTPURLResponse, (200...299).contains(responses.statusCode) else {
                            if let _ = response as? HTTPURLResponse {
                                if let data = data, let datas = String(data: data, encoding: .utf8) {
                                    print(datas)
                                    self.parseJSONMessageError(data)
                                }
                            }
                            return
                        }
                        
                        
                        self.delegate?.responseSucess()
                        
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            print(dataString)
                        }
                        
                        
                    }
                    task.resume()
                    
                }catch {
                    self.delegate?.didFailWithError(error)
                }
                
            }
        }
        
    }
    
    
    
    private func parseJSONMessageError(_ data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let error = json["message"] as? String {
                    self.delegate?.responseFailed(error)
                }
                if let error = json["messages"] as? [String] {
                    self.delegate?.responseFailed(error[0])
                }
            }
        } catch {
            self.delegate?.didFailWithError(error)
        }
    }
    
    
    
    
    
    public mutating func popDadosDoCliente(_ indexPath: IndexPath, _ estado: String, _ banner: MensagemBanner,_ selfView: EncomendasController, _ coordenadasDelegate: CoordenadasEncomendasDelegate?, _ listaModel: [ListaModel]){
        var banners = banner
        banners.bannerDelegate = selfView
        switch estado {
        case "ESPERA":
            banners.detalhesDaEncomenda(listaModel[indexPath.row])
            coord = CLLocationCoordinate2D(latitude: listaModel[indexPath.row].latitudeOrigem ?? 0.0, longitude: listaModel[indexPath.row].longitudeOrigem ?? 0.0)
             guard let coord = coord else {return}
             coordenadasDelegate?.atualizarCoordenadas(coord)
        case "ANDAMENTO":

            coord = CLLocationCoordinate2D(latitude: listaModel[indexPath.row ].latitudeDestino ?? 0.0, longitude: listaModel[indexPath.row ].longitudeDestino ?? 0.0)
            guard let coord = coord else {return}
            coordenadasDelegate?.atualizarCoordenadas(coord)
            if listaModel[indexPath.row].tipoPagamento == "WALLET" {
                banners.detalhesDaEncomenda(listaModel[indexPath.row], false, nil)
            }else if listaModel[indexPath.row].tipoPagamento == "TPA" {
                banners.detalhesDaEncomenda(listaModel[indexPath.row], false, false)
            }
        case "ENTREGUE":
            banners.detalhesDaEncomenda(listaModel[indexPath.row],nil,nil,true)
        default:
            return
        }
        
    }
    
    
    
    //MARK: - API LOGIN
    public func performLogin(_ url: String, _ dictionary: [String:Any], _ view: UIView){
        banners.progressBar(view, "Entrando...")
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string: url) {
                let session = URLSession(configuration: .default)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                let json = dictionary
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let task = session.uploadTask(with: urlRequest, from: jsonData) { (data, response, error) in
                        if error != nil {
                            guard let error = error else {return}
                            self.delegate?.didFailWithError(error)
                            return
                        }
                        
                        guard let responses = response as? HTTPURLResponse, (200...299).contains(responses.statusCode) else {
                            if let _ = response as? HTTPURLResponse {
                                if let data = data, let _ = String(data: data, encoding: .utf8) {
                                    self.parseJSONMessageError(data)
                                }
                            }
                            return
                        }
                        
                         self.delegate?.responseSucess()
                        
                        if let data = data, let _ = String(data: data, encoding: .utf8) {
                            self.parseJSON(data)
                        }
                        
                        
                    }
                    task.resume()
                    
                }catch {
                    self.delegate?.didFailWithError(error)
                }
                
            }
        }
        
    }
    
    
    private func parseJSON(_ data: Data){
        let keychain = KeychainSwift()
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(LoginResponse.self, from: data)
            if let token = decodedData.token_acesso, let dataExpiracao = decodedData.dataExpiracao, let rules = decodedData.papeis {
                //guardar dados na keychain
                keychain.set(token, forKey: Keys.token)
                keychain.set(dataExpiracao, forKey: Keys.dataExp)
                keychain.set(rules[0], forKey: Keys.rules)
                
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    //MARK: - API MOSTRAR DADOS USER
    
    
    func  mostrarDadosUser(_ url: String){
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string: url), let token = self.keychain.get(Keys.token)  {
                let session = URLSession(configuration: .default)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                let task = session.dataTask(with: urlRequest) { (data, response, error) in
                    if error != nil {
                        guard let error = error else {return}
                        self.dataSourcePerfil?.didFailWithError(error)
                        return
                    }
                    if let safeData = data {
                        if let dadosUsuario = self.jsonUserData(data: safeData) {
                            self.dataSourcePerfil?.didUpdateDadosUser(self, dadosUsuario)
                        }
                    }
                    
                }
                task.resume()
            }
        }
    }
    
    
    //PARSE JSON
    func jsonUserData(data: Data) -> PerfilModel? {

        let decoder = JSONDecoder()
        var perfilUsuario = PerfilModel()
        
        do {
            let dados = try decoder.decode(PerfilUser.self, from: data)
            perfilUsuario = PerfilModel(nome: dados.estafeta?.nome, sexo: dados.estafeta?.sexo, bilhete: dados.estafeta?.bilhete, telefone: dados.telefone, fotoUrl: dados.telefone, estadoEstafeta: dados.estafeta?.estadoEstafeta, email: dados.email, id: dados.estafeta?.id)
                return perfilUsuario
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
    
    
    
    
    
    
    
    func editarPerfileSenha(_ url: String, _ campos: [String:Any], _ view: UIView){
        self.banners.progressBar(view, "Aguarde...")
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string: url), let token = self.keychain.get(Keys.token)  {
                let session = URLSession(configuration: .default)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "PUT"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: campos, options: [])
                    let task = session.uploadTask(with: urlRequest, from: jsonData) { (data, response, error) in
                        if error != nil {
                            guard let error = error else {return}
                            self.delegate?.didFailWithError(error)
                            return
                        }
                        
                        guard let responses = response as? HTTPURLResponse, (200...299).contains(responses.statusCode) else {
                            if let _ = response as? HTTPURLResponse {
                                if let data = data, let datas = String(data: data, encoding: .utf8) {
                                    print(datas)
                                    self.parseJSONMessageError(data)
                                }
                            }
                            return
                        }
                        
                        
                        self.delegate?.responseSucess()
                        
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            print(dataString)
                        }
                        
                        
                    }
                    task.resume()
                    
                }catch {
                    self.delegate?.didFailWithError(error)
                }
                
            }
        }
    }
    
    
    
    
    
    
    //MARK: PopMenu Function
    func presentMenu(_ sender: UIBarButtonItem, _ viewController: MapController) {
        let popMenu = PopMenuViewController(sourceView: sender, actions: [
            PopMenuDefaultAction(title: "Meu Perfil", image: #imageLiteral(resourceName: "Grupo 94")),
            PopMenuDefaultAction(title: "Sair", image: #imageLiteral(resourceName: "sair"))
        ])
        popMenu.delegate = viewController
        popMenu.appearance.popMenuBackgroundStyle = .blurred(.dark)
        popMenu.appearance.popMenuColor.actionColor = .tint(#colorLiteral(red: 1, green: 0.3431279063, blue: 0, alpha: 1))
        popMenu.appearance.popMenuColor.backgroundColor = .solid(fill: UIColor.init(named: "FundoCor") ?? .white)
        popMenu.appearance.popMenuItemSeparator = .fill(#colorLiteral(red: 1, green: 0.3431279063, blue: 0, alpha: 1), height: 1)
        popMenu.appearance.popMenuActionHeight = 75
        viewController.present(popMenu, animated: true, completion: nil)
    }
    
    //Sair da sessão
    public func sairDaSessão(_ banners: MensagemBanner, _ selfView: MapController){
        banners.progressBar(selfView.view, "Saindo...")
        for i in keychain.allKeys {
            print(i)
            keychain.delete(i)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            banners.hideProgress(selfView.view)
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let inicio = mainStoryBoard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            let _ = UIApplication.shared.keyWindow?.rootViewController = inicio
            
        }
    }
    
    
    
    
}


struct Keys {
    static let token = "token"
    static let dataExp = "dataExp"
    static let rules = "rules"
}




protocol ListaEncomendasDelegate {
    func didStartRefreshing()
    func didUpdateListaEncomendas(_ apiService: APIService, _ listaEncomenda: [ListaModel])
    func didFailWithError(_ error: Error)
    func responseFailed(_ erroMessage: String)
    func responseSucess()
    
}


protocol PerfilDataSource {
    func didUpdateDadosUser(_ apiService: APIService, _ dadosUser: PerfilModel)
    func didFailWithError(_ error: Error)
}

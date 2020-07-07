//
//  EditarPerfilController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 2/7/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftMessages
import KeychainSwift

class EditarPerfilController: UIViewController {
    
    
    
    private let url = "http://52.14.171.89:8085/api/estafeta"
    private lazy var apiService = APIService()
    private lazy var banners = MensagemBanner()
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var telefoneTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nomeTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bilheteTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var generoTextField: SkyFloatingLabelTextFieldWithIcon!
    private let keychain = KeychainSwift()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.delegate = self
        retornarDados()
    }
    
    
    
    @IBAction func ConfirmareEditarButton(_ sender: UIButton) {
        apiService.editarPerfileSenha(url, enviarDadosEditados(), self.view)
    }
    
    
    @IBAction func FecharPopUpButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func retornarDados(){
        if let nome = keychain.get("nome"), let bi = keychain.get("bilhete"), let sexo = keychain.get("sexo"), let email = keychain.get("email"), let telefone = keychain.get("telefone") {
            nomeTextField.text = nome
            generoTextField.text = sexo
            emailTextField.text = email
            telefoneTextField.text = telefone
            bilheteTextField.text = bi
        }
    }
    
    
    
    private func enviarDadosEditados() -> [String:Any] {
        let json = ["nome" : nomeTextField.text ?? "", "bilhete" : bilheteTextField.text ?? "",
                    "email" : emailTextField.text ?? "", "sexo" : generoTextField.text ?? "",
                    "telefone" : telefoneTextField.text ?? ""]
        return json
    }
    
}





extension EditarPerfilController: ListaEncomendasDelegate {
    func didStartRefreshing() {}
    
    func didUpdateListaEncomendas(_ apiService: APIService, _ listaEncomenda: [ListaModel]) {}
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
           // selfView.dismiss(animated: true, completion: nil)
            selfView.banners.messageAlert(selfView, error.localizedDescription)
        }
    }
    
    func responseFailed(_ erroMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
           // selfView.dismiss(animated: true, completion: nil)
            selfView.banners.messageAlert(selfView, erroMessage)
            
        }
    }
    
    func responseSucess() {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            selfView.dismiss(animated: true, completion: nil)
            selfView.banners.MensagemSucess("Perfil Editado!")
        }
    }
    
    
    
    
}

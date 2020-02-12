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

class EditarPerfilController: UIViewController {
    
    
    
    private let url = "http://35.181.153.234:8085/api/estafeta"
    let json = ["email": "brian@gmail.com", "telefone": "928226455","bilhete": "00121333","nome": "Brian Michael","sexo": "string"]
    private lazy var apiService = APIService()
    private lazy var banners = MensagemBanner()
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var telefoneTextField: SkyFloatingLabelTextFieldWithIcon!
    
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.delegate = self
    }
    
    
    
    @IBAction func ConfirmareEditarButton(_ sender: UIButton) {
        apiService.editarPerfileSenha(url, json, self.view)
    }
    
    
    @IBAction func FecharPopUpButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension EditarPerfilController: ListaEncomendasDelegate {
    func didUpdateListaEncomendas(_ apiService: APIService, _ listaEncomenda: [ListaModel]) {}
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            selfView.dismiss(animated: true, completion: nil)
            selfView.banners.MensagemErro(error.localizedDescription)
        }
    }
    
    func responseFailed(_ erroMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            selfView.dismiss(animated: true, completion: nil)
            selfView.banners.MensagemErro(erroMessage)
            
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

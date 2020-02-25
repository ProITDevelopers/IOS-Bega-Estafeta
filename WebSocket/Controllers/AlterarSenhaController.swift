//
//  AlterarSenhaController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 2/9/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MBProgressHUD

class AlterarSenhaController: UIViewController {
    
    @IBOutlet weak var senhaAntigaTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var novaSenhaTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var repetirSenhaButton: SkyFloatingLabelTextFieldWithIcon!
    private var url = "http://35.181.153.234:8085/api/usuario/palavrapasse"
    private lazy var apiService = APIService()
    private lazy var banners = MensagemBanner()
    private var iconClick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.delegate = self
    }
    
    
    
    
    
    @IBAction func FecharPopUpButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func VerSenhaButton(_ sender: UIButton) {
        senhaAntigaTextField.isSecureTextEntry = iconClick
        novaSenhaTextField.isSecureTextEntry = iconClick
        repetirSenhaButton.isSecureTextEntry = iconClick
        iconClick = !iconClick
    }
    
    @IBAction func ConfirmarAlterarSenhaButton(_ sender: UIButton) {
        verificarCampos()
    }
    
    
    
    private func enviarDadosEditados(_ senhaAntiga: String, _ senhaNova: String) -> [String:Any] {
        let json = ["palavraPasseAtual" : senhaAntigaTextField.text ?? "", "palavraPasseNova" : novaSenhaTextField.text ?? ""]
        return json
    }
    
    private func verificarCampos(){
        guard let senhaAtual = senhaAntigaTextField.text, let senhaNova = novaSenhaTextField.text else {
            self.banners.messageAlert(self, "Algo Correu Mal")
            return
        }
        
        if senhaNova == repetirSenhaButton.text {
            apiService.editarPerfileSenha(url, enviarDadosEditados(senhaAtual, senhaNova), self.view)
        }else {
            banners.messageAlert(self, "As senhas não coincidem!")
        }
    }
    
    
}






extension AlterarSenhaController: ListaEncomendasDelegate {
    func didStartRefreshing() {}
    
    func didUpdateListaEncomendas(_ apiService: APIService, _ listaEncomenda: [ListaModel]) {}
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            //   selfView.dismiss(animated: true, completion: nil)
            selfView.banners.messageAlert(selfView, error.localizedDescription)
        }
    }
    
    func responseFailed(_ erroMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            //    selfView.dismiss(animated: true, completion: nil)
            selfView.banners.messageAlert(selfView, erroMessage)
            
        }
    }
    
    func responseSucess() {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            selfView.dismiss(animated: true, completion: nil)
            selfView.banners.MensagemSucess("Senha Alterada com sucesso!")
        }
    }
    
    
    
    
}

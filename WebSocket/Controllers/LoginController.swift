//
//  LoginController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/9/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import Network
import SwiftMessages
import SkyFloatingLabelTextField

class LoginController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var senhaTextField: SkyFloatingLabelTextFieldWithIcon!
    
    //let monitor = NWPathMonitor()
    private lazy var banner = MensagemBanner()
    //brian@gmail.com,senha:brian@gmail.com
    private lazy var functions = Functions()
    private lazy var apiService = APIService()
    private let url = "http://35.181.153.234:8085/api/login"
    private lazy var UserCredentials = [String:Any]()
    private var errorMessage: String? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let selfView = self else {return}
                if let erro = selfView.errorMessage {
                    selfView.banner.MensagemErro(erro)
                    selfView.banner.hideProgress(selfView.view)
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.delegate = self
        configurarNavigationBar()
    }
    
    
    
    @IBAction func entrar(_ sender: UIButton) {
        validarCredentials()
    }
    
    @IBAction func emailDidChange(_ sender: SkyFloatingLabelTextFieldWithIcon) {
        functions.verificarEmail(sender)
    }
    
    
    
    
    private func validarCredentials(){
        guard let email = emailTextField.text, let senha = senhaTextField.text ,email.count > 0, senha.count > 0 else {
            banner.MensagemErro("Preencha os Campos!")
            return
        }
        UserCredentials = ["email":email,"palavraPasse":senha]
        apiService.performLogin(url,UserCredentials,self.view)
    }
    
    
    
    
    private func configurarNavigationBar(){
        //por a cor transparente o navigation
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    
}





extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}





extension LoginController: ListaEncomendasDelegate {
    func responseSucess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let selfView = self else {return}
            selfView.banner.hideProgress(selfView.view)
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let inicio = mainStoryBoard.instantiateViewController(withIdentifier: "inicial") as! UINavigationController
            let _ = UIApplication.shared.keyWindow?.rootViewController = inicio
            
        }
    }
    
    
    func didUpdateListaEncomendas(_ apiService: APIService, _ listaEncomenda: [ListaModel]) {}
    func didFailWithError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func responseFailed(_ erroMessage: String) {
        errorMessage = erroMessage
    }
    
    
}

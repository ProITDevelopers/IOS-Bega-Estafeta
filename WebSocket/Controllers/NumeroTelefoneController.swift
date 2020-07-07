//
//  NumeroTelefoneController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 2/21/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MBProgressHUD

class NumeroTelefoneController: UIViewController {
    
    
    private var url = "http://52.14.171.89:8085/api/usuario/telefone"
    let json = ["telefone": "928226458"]
    private lazy var apiService = APIService()
    private lazy var banners = MensagemBanner()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fecharPopUp(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ConfirmarTelefone(_ sender: UIButton) {
        apiService.confirmarTelefoneECodigo(url, json, self.view)
    }
    
    @IBAction func Cancelar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}





extension NumeroTelefoneController: ListaEncomendasDelegate {
    func didStartRefreshing() {}
    
    func didUpdateListaEncomendas(_ apiService: APIService, _ listaEncomenda: [ListaModel]) {}
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            selfView.dismiss(animated: true, completion: nil)
            print(error)
            //selfView.banners.MensagemErro(error.localizedDescription)
        }
    }
    
    func responseFailed(_ erroMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            selfView.dismiss(animated: true, completion: nil)
            print(erroMessage)
            //selfView.banners.MensagemErro(erroMessage)
            
        }
    }
    
    func responseSucess() {
        DispatchQueue.main.async { [weak self] in
            guard let selfView = self else {return}
            selfView.banners.hideProgress(selfView.view)
            selfView.performSegue(withIdentifier: "code", sender: selfView)
        }
    }
    
    
    
    
}

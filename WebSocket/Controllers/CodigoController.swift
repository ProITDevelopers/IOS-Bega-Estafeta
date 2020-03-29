//
//  CodigoController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 2/21/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MBProgressHUD

class CodigoController: UIViewController {
    
    
    
    private var url = "https://motoboyentrega.begaentrega.com/api/usuario/codigo"
    let json = ["codigo": "928226458"]
    private lazy var apiService = APIService()
    private lazy var banners = MensagemBanner()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    
    
    @IBAction func fecharPopUp(_ sender: UIBarButtonItem) {
        apiService.messageAlert(self)
    }
    
    @IBAction func ConfirmarTelefone(_ sender: UIButton) {
        apiService.confirmarTelefoneECodigo(url, json, self.view)
    }
  
    

}





extension CodigoController: ListaEncomendasDelegate {
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
            selfView.performSegue(withIdentifier: "newpass", sender: selfView)
        }
    }
    
    
    
    
}


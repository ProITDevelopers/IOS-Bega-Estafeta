//
//  PerfilController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 2/5/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import SwiftMessages
import SkyFloatingLabelTextField
import SkeletonView
import KeychainSwift

class PerfilController: UIViewController {
    
    
    @IBOutlet weak var fotoUser: ImagemCircular!
    @IBOutlet weak var nomeUser: UILabel!
    @IBOutlet weak var bilheteUser: UILabel!
    @IBOutlet weak var sexoUser: UILabel!
    @IBOutlet weak var telefoneUser: UILabel!
    @IBOutlet weak var emailUser: UILabel!
    
    
    private lazy var apiService = APIService()
    private lazy var banner = MensagemBanner()
    private lazy var  keychain = KeychainSwift()
    private let urlUser = "http://35.181.153.234:8085/api/usuario/perfil"
    
    private var dados = PerfilModel() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.view.hideSkeleton(transition: .crossDissolve(0.25))
                self?.nomeUser.text = "  Nome: \(self?.dados.nome ?? "")"
                self?.bilheteUser.text = "  Bilhte nº: \(self?.dados.bilhete ?? "")"
                self?.sexoUser.text = "  Sexo: \(self?.dados.sexo ?? "")"
                self?.telefoneUser.text = "  Telefone nº: \(self?.dados.telefone ?? "")"
                self?.emailUser.text = "  Email: \(self?.dados.email ?? "")"
                self?.guardarDadosUser()
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
        configurarNavigationBar()
        view.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        apiService.dataSourcePerfil = self
        apiService.mostrarDadosUser(urlUser)
    }
    
    
    private func guardarDadosUser(){
        keychain.set(self.dados.nome ?? "", forKey: "nome")
        keychain.set(self.dados.bilhete ?? "", forKey: "bilhete")
        keychain.set(self.dados.sexo ?? "", forKey: "sexo")
        keychain.set(self.dados.email ?? "", forKey: "email")
        keychain.set(self.dados.telefone ?? "", forKey: "telefone")
    }
    
    private func configurarNavigationBar(){
        //por a cor transparente o navigation
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    

}


extension PerfilController: PerfilDataSource {
    
    func didUpdateDadosUser(_ apiService: APIService, _ dadosUser: PerfilModel) {
            dados = dadosUser
    }
    
    func didFailWithError(_ error: Error) {
        errors = error.localizedDescription
    }
    
    
}

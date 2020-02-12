//
//  DefinicoesController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/31/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import KeychainSwift

class DefinicoesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private lazy var keychain = KeychainSwift()
    private lazy var bannners = MensagemBanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarNavigationBar()
        tableView.register(UINib.init(nibName: "PerfilCell", bundle: nil), forCellReuseIdentifier: "cells")
        tableView.register(UINib.init(nibName: "DefinicoesCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    
    
    private func sairDaSessão(){
        bannners.progressBar(self.view, "Saindo...")
        for i in keychain.allKeys {
            print(i)
            keychain.delete(i)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let selfView = self else {return}
            selfView.bannners.hideProgress(selfView.view)
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let inicio = mainStoryBoard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            let _ = UIApplication.shared.keyWindow?.rootViewController = inicio
            
        }
    }
    
    private func configurarNavigationBar(){
        //por a cor transparente o navigation
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    



}




extension DefinicoesController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath) as! PerfilCell
            cell.textoLabel.text = "Perfil"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DefinicoesCell
            cell.dados = "Sair"
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Perfil"
        case 1:
            return ""
        default:
            return ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "perfil", sender: self)
        case 1:
            sairDaSessão()
        default:
            return
        }
    }

    
    
    
}

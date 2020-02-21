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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    @IBAction func FecharPopUpButton(_ sender: UIBarButtonItem) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func VerSenhaButton(_ sender: UIButton) {
        
    }
    
    @IBAction func ConfirmarAlterarSenhaButton(_ sender: UIButton) {

    }
    
    
}

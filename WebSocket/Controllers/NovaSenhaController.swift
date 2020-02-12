//
//  NovaSenhaController.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/9/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import SwiftMessages

class NovaSenhaController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated:true)
        
//
//        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
//        // files in the main bundle first, so you can easily copy them into your project and make changes.
//        let view = MessageView.viewFromNib(layout: .cardView)
//
//        // Theme message elements with the warning style.
//        view.configureTheme(.success)
//
//        // Add a drop shadow.
//        view.configureDropShadow()
//
//        // Set message title, body, and icon. Here, we're overriding the default warning
//        // image with an emoji character.
//        //let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
//        view.configureContent(title: "AVISO", body: "OPAH", iconImage: #imageLiteral(resourceName: "Buton App Store Bega 1"), iconText: nil, buttonImage: nil, buttonTitle: "Sair", buttonTapHandler: { _ in SwiftMessages.hide() })
//
////        view.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
////        view.backgroundView.layer.cornerRadius = 10
//        view.button?.isHidden = true
//     //  view.tapHandler = { _ in SwiftMessages.hide() }
//
//
//        // Increase the external margin around the card. In general, the effect of this setting
//        // depends on how the given layout is constrained to the layout margins.
//        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//
//        // Reduce the corner radius (applicable to layouts featuring rounded corners).
//        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
//
//
//
//        // Show the message.
//        var config = SwiftMessages.defaultConfig
//        config.duration = .forever
//        config.presentationStyle = .bottom
//        config.dimMode = .blur(style: .dark, alpha: 1.0, interactive: true)
//        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
//        SwiftMessages.show(config: config, view: view)
    }
    

    @IBAction func cancelarAlterarSenha(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}

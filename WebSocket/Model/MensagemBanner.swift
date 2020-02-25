//
//  MensagemBanner.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/10/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import Foundation
import SwiftMessages
import MBProgressHUD



struct MensagemBanner {
    
    weak var bannerDelegate: BannerDelegate?
    let descricao = ""
    

    
    public func MensagemNoMapa(_ title: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView )
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: title, body: nil, iconImage: #imageLiteral(resourceName: "Buton App Store Bega 1"), iconText: nil, buttonImage: nil, buttonTitle: "OK") { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1)
        messageView.titleLabel?.textColor = .white
        messageView.button?.tintColor = .black
        messageView.button?.backgroundColor = .white
        messageView.button?.layer.cornerRadius = 10
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1.0, interactive: true)
        config.presentationContext  = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    
    public func detalhesDaEncomenda(_ dados: ListaModel?=nil,_ isHiddenCodigo: Bool?=nil, _ isHiddenTransacao: Bool?=nil, _ isHiddenButtons: Bool?=nil) {
        
        do {
            let view: TacoDialogView = try SwiftMessages.viewFromNib()
            view.configureDropShadow()
            view.dadosEncomenda = dados
            view.codigoTextField.isHidden = isHiddenCodigo ?? true
            view.numeroTransacaoTextField.isHidden = isHiddenTransacao ?? true
            view.confirmarButtons.isHidden = isHiddenButtons ?? false
            view.mostrarRotaButton.isHidden = isHiddenButtons ?? false
            
            view.getTacosAction = {
                self.bannerDelegate?.mostrarRota()
                SwiftMessages.hide()
            }
            view.confirmarButton = { idEncomenda in
                self.bannerDelegate?.botaoConfirmar(idEncomenda)
                SwiftMessages.hide()
            }
            
            view.confirmarEntregaCliente = { tipoPagamento, id, json in
                self.bannerDelegate?.confirmarEntregaCliente(tipoPagamento, id, json)
                SwiftMessages.hide()
            }
            //view.cancelAction = { SwiftMessages.hide() }
            var config = SwiftMessages.defaultConfig
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            config.duration = .forever
            config.presentationStyle = .center
            config.keyboardTrackingView = KeyboardTrackingView()
            config.dimMode = .blur(style: .dark, alpha: 1.0, interactive: true)
            SwiftMessages.show(config: config, view: view)
            
        }catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    
    
    
    
    public func MensagemErro(_ title: String) {

        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()
        
        view.configureContent(title: "", body: title, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.configureTheme(.error, iconStyle: .default)
        view.button?.isHidden = true
        
        view.tapHandler = { _ in SwiftMessages.hide() }
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        
        
        // Show the message.
        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: 1.5)
        config.presentationStyle = .bottom
        config.dimMode = .none
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: view)
    }
    
    
    public func MensagemSucess(_ texto: String?=nil) {

          let view = MessageView.viewFromNib(layout: .messageView)
          view.configureTheme(.success)
          view.configureDropShadow()
          
          view.configureContent(title: "Sucesso!", body: texto ?? "", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
          view.configureTheme(.success, iconStyle: .default)
          view.button?.isHidden = true
          
          view.tapHandler = { _ in SwiftMessages.hide() }
          view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
          (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
          
          
          
          // Show the message.
          var config = SwiftMessages.defaultConfig
          config.duration = .seconds(seconds: 1.5)
          config.presentationStyle = .bottom
          config.dimMode = .none
          config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
          SwiftMessages.show(config: config, view: view)
      }
    
    
    
    
    
    
    
    func progressBar(_ view: UIView, _ texto: String, _ enable: Bool?=nil){
         let propressBar = MBProgressHUD.showAdded(to: view, animated: true)
         propressBar.mode = .indeterminate
         propressBar.isUserInteractionEnabled = enable ?? false
        // propressBar.backgroundView.style = .blur
         propressBar.contentColor = #colorLiteral(red: 1, green: 0.3431279063, blue: 0, alpha: 1)
       // propressBar.bezelView.color = UIColor.init(named: "FundoCor") ?? UIColor.white
         //propressBar.mode = .customView
        // propressBar.customView = UIImageView(image: #imageLiteral(resourceName: "Grupo 94"))
         propressBar.label.text = texto
    }
    
    func hideProgress(_ view: UIView){
         let _ = MBProgressHUD.hide(for: view, animated: true)
    }
    
    
    //uialert message
    public func messageAlert(_ viewController: UIViewController, _ message: String) {
        let alert = UIAlertController(title: "Alerta!", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }

    
}



protocol BannerDelegate: class {
    func mostrarRota()
    func botaoConfirmar(_ idEncomenda: Int?)
    func confirmarEntregaCliente(_ pagamento: String, _ idEncomenda: String, _ json: [String:Any])
}



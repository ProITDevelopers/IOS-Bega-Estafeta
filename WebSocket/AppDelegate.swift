//
//  AppDelegate.swift
//  WebSocket
//
//  Created by Brian Hashirama on 12/23/19.
//  Copyright © 2019 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private lazy var keychain = KeychainSwift()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        compararDataExpoiracao()
        return true
    }
    
    func compararDataExpoiracao(){
        let dateFormatter = DateFormatter()
        let dataAtual = Date()
        guard let dataExpr = keychain.get(Keys.dataExp) else {return}
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dataString = dateFormatter.string(from: dataAtual)
        guard let dataExp = dateFormatter.date(from: dataExpr) else {return}
        guard let dataAtualDate = dateFormatter.date(from: dataString) else {return}
        if dataAtualDate > dataExp {
            return
        }else{
            if let token = keychain.get(Keys.token), !token.isEmpty {
                let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let inicio = mainStoryBoard.instantiateViewController(withIdentifier: "inicial") as! UINavigationController
                self.window?.rootViewController = inicio
            }
        }
    }
    
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    
    
    
    
    
}


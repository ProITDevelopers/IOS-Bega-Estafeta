//
//  SceneDelegate.swift
//  WebSocket
//
//  Created by Brian Hashirama on 12/23/19.
//  Copyright © 2019 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import KeychainSwift

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private lazy var keychain = KeychainSwift()
    private lazy var banner = MensagemBanner()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        compararDataExpoiracao(windowScene)
    
    }

@available(iOS 13.0, *)
func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

@available(iOS 13.0, *)
func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    
    }

@available(iOS 13.0, *)
func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

@available(iOS 13.0, *)
func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

@available(iOS 13.0, *)
func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information

        // to restore the scene back to its current state.
    }
    
    
    
    private func compararDataExpoiracao(_ windowScene: UIWindowScene){
        let dateFormatter = DateFormatter()
        let dataAtual = Date()
        guard let dataExpr = keychain.get(Keys.dataExp) else {return}
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dataString = dateFormatter.string(from: dataAtual)
        guard let dataExp = dateFormatter.date(from: dataExpr) else {return}
        guard let dataAtualDate = dateFormatter.date(from: dataString) else {return}
        if dataAtualDate > dataExp {
            banner.MensagemErro("Sessão Expirada!")
            return
        }else{
            guard let _ = keychain.get(Keys.token) else {return}
            self.window = UIWindow(windowScene: windowScene)
            let initialViewController =
                storyboard.instantiateViewController(withIdentifier: "inicial") as! UINavigationController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }


}


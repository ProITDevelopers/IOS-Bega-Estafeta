//
//  Segues.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/13/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import Foundation
import SwiftMessages

import UIKit
import SwiftMessages

class ViewControllersViewController: UIViewController {
    
    @objc @IBAction private func dismissPresented(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}

class SwiftMessagesCenteredSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .centered)
        dimMode = .blur(style: .dark, alpha: 0.9, interactive: false)
        messageView.configureDropShadow()
       // keyboardTrackingView = KeyboardTrackingView()
    }
}

class SwiftMessagesCenteredProfile: SwiftMessagesSegue {
    
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .centered)
        dimMode = .blur(style: .dark, alpha: 0.9, interactive: false)
        messageView.configureDropShadow()
        messageView.backgroundHeight = 550.0
    }
}

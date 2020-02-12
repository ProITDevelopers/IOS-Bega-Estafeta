//
//  DefinicoesCell.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/31/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit

class DefinicoesCell: UITableViewCell {

    var dados: String? {
        didSet{
            textLabel?.text = dados
        }
    }
    
}

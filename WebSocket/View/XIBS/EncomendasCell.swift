//
//  EncomendasCell.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/29/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit

class EncomendasCell: UITableViewCell {

    
    @IBOutlet weak var numeroDePedidos: UIButton!
    @IBOutlet weak var tituloTextField: UILabel!
    @IBOutlet weak var dataTextField: UILabel!
    
//    var numeroPedidos: String? {
//        didSet {
//            self.numeroDePedidos.setTitle(numeroPedidos, for: .normal)
//        }
//    }
    
    var dadosLista: ListaModel? {
        didSet {
            self.textLabel?.text = dadosLista?.nomeLoja
            self.detailTextLabel?.text = dadosLista?.dataCovertida
        }
    }

}

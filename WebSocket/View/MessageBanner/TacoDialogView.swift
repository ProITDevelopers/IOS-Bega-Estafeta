//
//  TacoDialogView.swift
//  Demo
//
//  Created by Tim Moose on 8/12/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages
import SkyFloatingLabelTextField









class TacoDialogView: MessageView {
    
    
    @IBOutlet weak var nomeLoja: UILabel?
    @IBOutlet weak var nomeCliente: UILabel?
    @IBOutlet weak var quatidadePedido: UILabel?
    @IBOutlet weak var tipoPagamento: UILabel?
    @IBOutlet weak var data: UILabel?
    @IBOutlet weak var numeroTelefone: UILabel?
    @IBOutlet weak var IDFatura: UILabel!
    @IBOutlet weak var codigoTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var numeroTransacaoTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var confirmarButtons: UIButton!
    @IBOutlet weak var mostrarRotaButton: UIButton!
    
    private lazy var functions = Functions()
    
    
    var dadosEncomenda: ListaModel? {
        didSet {
            IDFatura?.text = "Fatura nº: \(dadosEncomenda?.idFatura ?? "")"
            nomeLoja?.text = dadosEncomenda?.nomeLoja
            nomeCliente?.text = "Nome: \(dadosEncomenda?.nomeCliente ?? "")"
            tipoPagamento?.text = "Tipo de Pagamento: \(dadosEncomenda?.tipoPagamento ?? "")"
            data?.text = "Data: \(dadosEncomenda?.dataCovertida ?? "")"
            numeroTelefone?.text = "Nº de Telefone: \(dadosEncomenda?.telefoneCliente ?? "")"
            
        }
    }
    
    
    
    var getTacosAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    var confirmarButton: ((_ idEncomenda: Int) -> Void)?
    var confirmarEntregaCliente: ((_ pagamento: String, _ idEncomenda: String, _ json: [String:Any]) -> Void)?
    
    
    
    @IBAction func confirmarEntrega() {
        
        if !codigoTextField.isHidden && !numeroTransacaoTextField.isHidden {
            guard let id = dadosEncomenda?.id else {return}
            guard let codigoWallet = codigoTextField.text,let numeroTrans = numeroTransacaoTextField.text ,codigoWallet.count > 0, numeroTrans.count > 0 else {
                codigoTextField.errorMessage = "Código"
                numeroTransacaoTextField.errorMessage = "Nº de Transação"
                return
            }
            
            confirmarEntregaCliente?(dadosEncomenda?.tipoPagamento ?? "", String(id), ["codigo":codigoWallet,"numeroTransacao":numeroTrans])
            
        }else if !codigoTextField.isHidden {
            guard let id = dadosEncomenda?.id else {return}
            guard let codigoWallet = codigoTextField.text ,codigoWallet.count > 0 else {
                codigoTextField.placeholder = "Preencha o Campo"
                return
            }
            confirmarEntregaCliente?(dadosEncomenda?.tipoPagamento ?? "", String(id), ["codigo":codigoWallet])
            
        }else{
            guard let id = dadosEncomenda?.id else {return}
            confirmarButton?(id)
        }
        
        
        
    }
    
    @IBAction func mostrarRotaNoMapa(_ sender: Any) {
        getTacosAction?()
    }
    
    
    @IBAction func listaDeEncomendas() {
        SwiftMessages.hide()
    }
    
    
    
    
    
    
    
}

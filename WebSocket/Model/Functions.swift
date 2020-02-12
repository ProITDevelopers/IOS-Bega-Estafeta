//
//  Functions.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/31/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

extension String {
    
    enum ValidarTipo {
        case email
    }
    
    enum Regex: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    
    func dadoValido(_ valido: ValidarTipo) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch valido {
        case .email:
            regex = Regex.email.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
}


struct Functions {
    
    private let validarEmail: String.ValidarTipo = .email
    private let apiRequest = APIService()
    
    
    public func verificarEmail(_ email: SkyFloatingLabelTextField) {
        guard let emailValido = email.text else {return}
        if emailValido.dadoValido(validarEmail) {
            email.errorMessage = ""
        }else{
            email.errorMessage = "Email Inválido!"
        }
        
    }
    
    
    
    public func verificarTipoDePagamento(_ pagamento: String, _ idEncomenda: String, _ json: [String:Any]){
        
        switch pagamento {
        case "WALLET":
            apiRequest.performPUTrequest("http://35.181.153.234:8085/api/encomenda/\(idEncomenda)/pagamento/wallet/estafeta", nil, json)
            
        case "TPA":
            apiRequest.performPUTrequest("url", nil, json)
        default:
            return
        }
        
    }
    
    
}

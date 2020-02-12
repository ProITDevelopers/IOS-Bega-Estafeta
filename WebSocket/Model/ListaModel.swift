//
//  ListaModel.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/22/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit
import MapKit

struct ListaModel {
    
    public var nomeCliente: String?
    public var nomeLoja: String?
    public var telefoneCliente: String?
    public var dataCriacao: String?
    public var estadoEncomenda: String?
    public var latitudeOrigem: Double?
    public var longitudeOrigem: Double?
    public var tipoPagamento: String?
    public var valor: Double?
    public var idFatura: String?
    public var id: Int?
    var longitudeDestino: Double?
    var latitudeDestino: Double?
    
    
    
    public var dataCovertida: String {
        if let dataConvertida = dataCriacao {
            return converterData(data: dataConvertida)
        }else {
            return "----"
        }
        
    }
    
    
    
    
    private func converterData(data: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: data) {
            dateFormatter.locale = Locale(identifier: "pt_PT")
            dateFormatter.dateFormat = "d MMMM yyyy, HH:mm"
            return dateFormatter.string(from: date)
        }
        return data
    }
    
    
    
    
    
    
    
}


struct PerfilModel {
    
    public var nome: String?
    public var sexo: String?
    public var bilhete: String?
    public var telefone: String?
    public var fotoUrl: String?
    public var estadoEstafeta: String?
    public var email: String?
    public var id: Int?
    
}

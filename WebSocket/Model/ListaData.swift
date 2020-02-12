//
//  ListaModel.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/22/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import Foundation


struct ListaData: Decodable {
    var nomeCliente: String?
    var nomeLoja: String?
    var telefoneCliente: String?
    var dataCriacao: String?
    var estadoEncomenda: String?
    var pontoReferencia: String?
    var tipoPagamento: String?
    var latitudeOrigem: Double?
    var longitudeOrigem: Double?
    var valor: Double?
    var idFatura: String?
    var id: Int?
    var longitudeDestino: Double?
    var latitudeDestino: Double?
}



struct LoginResponse: Decodable {
    var dataExpiracao: String?
    var papeis: [String]?
    var token_acesso: String?
}




struct PerfilUser: Decodable {
    var estafeta: Dados?
    var fotoUrl: String?
    var email: String?
    var telefone: String?
}

struct Dados: Decodable {
    var nome: String?
    var sexo: String?
    var estadoEstafeta: String?
    var bilhete: String?
    var id: Int?
}

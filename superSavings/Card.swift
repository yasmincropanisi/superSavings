//
//  Card.swift
//  TeenCard
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import UIKit
import CloudKit
import AgillitasClient

class Card:NovoCartao {

    var record: CKRecord!
    var history:History?
    var id:Int?
    var blocked:Int?
    var number:String?
    var users: [User]?

    
    
    init(withRecord record: CKRecord) {
        super.init()
        self.record = record
        self.id = record["id"] as? Int ?? 0
        self.number = record["number"] as? String
        self.contrasenha = record["countersign"] as? String
        self.valor = record["found"] as? Double
        self.blocked = record["blocked"] as? Int ?? 0
        self.idCartao = record["number"] as? String

        
    }
    init(number:String) {
        self.number = number
    }
}

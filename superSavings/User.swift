//
//  User.swift
//  TeenCard
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import UIKit
import CloudKit
import AgillitasClient

import UIKit
import CloudKit

class User: NovoCartaoPortador {
    
    //private(set) static var shared = User()
    // Cloudkit Record
    var record: CKRecord!
    var id: Int?
    var cards: [Card]?
    var email:String?
    var password:String?
    var isGuardian:Int?
    
    // private override init() {
    //   super.init()
    // }
    /// receive the person record and load its informations
    ///
    /// - Parameter record: person record in the database
    init(email: String) {
        super.init()
        self.email = email
        
    }
    
    init(withRecord record: CKRecord) {
        super.init()
        self.record = record
        self.id = record["id"] as? Int ?? 0
        self.nome = record["name"] as? String
        self.email = record["email"] as? String
        self.sobrenome = record["lastname"] as? String
        self.contato?.telCelular = record["phone"] as? String
        self.contato?.telResidencial = record["celular"] as? String
        self.cpf = record["cpf"] as? String
        self.dataNascimento = record["dateOfBirth"] as? Date
        self.password = record["password"] as? String
        self.isGuardian = record["isGuardian"] as? Int ?? 0
        
        
    }
}

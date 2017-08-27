//
//  UserServicesDelegate.swift
//  TeenCard
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import UIKit
import CloudKit



/// Responsibilities for the one who uses 'PersonServices'
protocol UserServicesDelegate: NSObjectProtocol {
    
    /// Received array of person from DB
    ///
    /// - Parameter User: array of Person
    func didReceivedUser(user: [User])
    
    /// Called when it was unable to retrieve User data
    func failedToGetUser(errorMessage: String)
    
    /// Called when a person record is created
    ///
    /// - Parameter record: person record
    func didCreatedUser(record: CKRecord)
    
    /// Called when it was unable to create the person record
    ///
    /// - Parameter errorMessage: message describing the error to the user
    func failedToCreateUser(errorMessage: String)
    
    /// Called when a person record is updated
    func didUpdatedUser(newRecord: CKRecord)
    
    /// Called when it was unable to update the person record
    ///
    /// - Parameter errorMessage: message describing the error to the user
    func failedToUpdateUser(errorMessage: String)
    
    
    //    func didDeleteRecord()
    //
    //    func failedToDelete(errorMessage: String)
    
}
extension UserServicesDelegate {
    func didReceivedUser(user: [User]) {}
    func failedToGetUser(errorMessage: String) {}
    func didCreatedUser(record: CKRecord) {}
    func failedToCreateUser(errorMessage: String){}
    func didUpdatedUser(newRecord: CKRecord) {}
    func failedToUpdateUser(errorMessage: String){}
    
}
class UserServices {
    
    var delegate: UserServicesDelegate?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    // MARK: Query operations
    func getAllUser() {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let predicate = NSPredicate(format: "name != '-1'")
        
        performQueryOperation(predicate: predicate)
    }
    
    func getUser(id: Int) {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", id)
        
        performQueryOperation(predicate: predicate)
        
    }
    
    func getUser(name: String) {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let predicate = NSPredicate(format: "name == %@", name)
        
        performQueryOperation(predicate: predicate)
    }
    
    func getUser(email: String) {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let predicate = NSPredicate(format: "email == %@", email)
        
        performQueryOperation(predicate: predicate)
    }
    
    func getUser(card: Card){
        
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let userReference = CKReference(record: card.record, action: .deleteSelf)
        let predicate = NSPredicate(format: "cards CONTAINS %@", userReference)
        
        performQueryOperation(predicate: predicate)
    }
    
    func performQueryOperation(predicate: NSPredicate){
        var users = [User]()
        
        let query = CKQuery(recordType: "User", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.recordFetchedBlock = { record in
            let user = User(withRecord: record)
            users.append(user)
        }
        queryOp.queryCompletionBlock = { (cursor, error) in
            if error == nil {
                // TODO: usar cursor para carregar o resto dos dados
                print("User fetched\n")
                DispatchQueue.main.async {
                    self.delegate!.didReceivedUser(user: users)
                }
            }else {
                let errorInfo = ErrorController.shared.handleCKError(error: error as! CKError)
                
                if errorInfo.shouldRetry {
                    DispatchQueue.main.async {
                        self.performQueryOperation(predicate: predicate)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate!.failedToGetUser(errorMessage: errorInfo.message)
                    }
                }
            }
        }
        
        publicDB.add(queryOp)
    }
    
    
    // MARK: Create record operation
    func createUser(user: User) {
        // TODO: verificar se ja nao existe usuario com esse nome
        
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let userRecord = CKRecord(recordType: "User")
        
        userRecord["id"] = user.id! as NSInteger as CKRecordValue
        userRecord["lastname"] = user.sobrenome! as NSString
        userRecord["CPF"] = user.cpf! as NSString
        userRecord["dateOfBirth"] = user.dataNascimento as! CKRecordValue
        userRecord["phone"] = user.contato?.telResidencial as! NSString
        userRecord["password"] = user.password as! NSString
        userRecord["isGuardian"] = user.isGuardian as! NSInteger as CKRecordValue
        userRecord["celular"] = user.contato?.telCelular as! NSString
        userRecord["city"] = user.endereco?.cidade as! NSString
        userRecord["complement"] = user.endereco?.complemento as! NSString
        userRecord["state"] = user.endereco?.estado as! NSString
        userRecord["street"] = user.endereco?.logradouro as! NSString
        userRecord["zipcode"] = user.endereco?.codigoPostal as! NSString
        
        
        
        
        
        if let name = user.nome {
            userRecord["name"] = name as NSString
        }
        if let email = user.email {
            userRecord["email"] = email as NSString
        }
        var cards = [CKReference]()
        if let listCards =   user.cards {
            for card in listCards {
                cards.append(CKReference(record: card.record, action: .none))
            }
            userRecord["cards"] = cards as NSArray
        }
        
        self.publicDB.save(userRecord){
            (record, error) in
            if error == nil {
                print("User created\n")
                DispatchQueue.main.async {
                    self.delegate!.didCreatedUser(record: record!)
                }
            }else {
                let errorInfo = ErrorController.shared.handleCKError(error: error as! CKError)
                
                if errorInfo.shouldRetry {
                    DispatchQueue.main.async {
                        self.createUser(user: user)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate!.failedToCreateUser(errorMessage: errorInfo.message)
                    }
                }
            }
        }
        
    }
    
    // MARK: Update record operation
    func updateUser(user: User) {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        guard user.record != nil else {
            let message = "You must create the record before update it"
            print("Error: \(message)\n")
            DispatchQueue.main.async {
                self.delegate!.failedToUpdateUser(errorMessage: message)
            }
            return
        }
        let userRecord = CKRecord(recordType: "User")
        
        userRecord["id"] = user.id! as NSInteger as CKRecordValue
        userRecord["lastname"] = user.sobrenome! as NSString
        userRecord["CPF"] = user.cpf! as NSString
        userRecord["dateOfBirth"] = user.dataNascimento as! CKRecordValue
        userRecord["phone"] = user.contato?.telResidencial as! NSString
        userRecord["password"] = user.password as! NSString
        userRecord["isGuardian"] = user.isGuardian as! NSInteger as CKRecordValue
        userRecord["celular"] = user.contato?.telCelular as! NSString
        userRecord["city"] = user.endereco?.cidade as! NSString
        userRecord["complement"] = user.endereco?.complemento as! NSString
        userRecord["state"] = user.endereco?.estado as! NSString
        userRecord["street"] = user.endereco?.logradouro as! NSString
        userRecord["zipcode"] = user.endereco?.codigoPostal as! NSString        /*var cards = [CKReference]()
         if  user.cards! != nil {
         for card in user.cards! {
         cards.append(CKReference(record: card.record, action: .none))
         }
         userRecord["cards"] = cards as NSArray
         }*/
        
        if let name = user.nome {
            userRecord["name"] = name as NSString
        }
        if let email = user.email {
            userRecord["email"] = email as NSString
        }
        
        
        
        saveUpdatedRecord(of: user)
    }
    
    private func saveUpdatedRecord(of user: User){
        print(user.nome)
        self.publicDB.save(user.record){
            (record, error) in
            if error == nil {
                print("User updated\n")
                //UserInfoController.shared.refresh()
                DispatchQueue.main.async {
                    self.delegate!.didUpdatedUser(newRecord: record!)
                }
                print(record)
            }else {
                let errorInfo = ErrorController.shared.handleCKError(error: error as! CKError)
                
                if errorInfo.shouldRetry {
                    DispatchQueue.main.async {
                        self.saveUpdatedRecord(of: user)
                    }
                } else if errorInfo.concurrentAccessError {
                    let ckerror = error as! CKError
                    let serverRecord = ckerror.userInfo[CKRecordChangedErrorServerRecordKey] as! CKRecord
                    let clientRecord = ckerror.userInfo[CKRecordChangedErrorClientRecordKey] as! CKRecord
                    let ancestorRecord = ckerror.userInfo[CKRecordChangedErrorAncestorRecordKey] as! CKRecord
                    
                    user.record = serverRecord
                    self.updateUser(user: user)
                    
                }else {
                    DispatchQueue.main.async {
                        self.delegate!.failedToUpdateUser(errorMessage: errorInfo.message)
                    }
                }
            }
        }
    }
    
    private func concurrentAccessToField(field: String, error: CKError) -> NSNumber {
        let ckerror = error
        let serverRecord = ckerror.userInfo[CKRecordChangedErrorServerRecordKey] as! CKRecord
        let clientRecord = ckerror.userInfo[CKRecordChangedErrorClientRecordKey] as! CKRecord
        let ancestorRecord = ckerror.userInfo[CKRecordChangedErrorAncestorRecordKey] as! CKRecord
        
        let serverValue = serverRecord[field] as! Int
        let clientvalue = clientRecord[field] as! Int
        let ancestorValue = ancestorRecord[field] as! Int
        
        return (serverValue + clientvalue - ancestorValue) as NSNumber
    }
    
    
}


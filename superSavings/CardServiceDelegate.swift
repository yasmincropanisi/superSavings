//
//  CardServiceDelegate.swift
//  TeenCard
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import UIKit
import CloudKit
/// Responsibilities for the one who uses 'PersonServices'
protocol CardServicesDelegate: NSObjectProtocol {
    
    /// Received array of person from DB
    ///
    /// - Parameter User: array of Person
    func didReceivedCard(card: [Card])
    
    /// Called when it was unable to retrieve User data
    func failedToGetCard(errorMessage: String)
    
    /// Called when a person record is created
    ///
    /// - Parameter record: person record
    func didCreatedCard(record: CKRecord)
    
    /// Called when it was unable to create the person record
    ///
    /// - Parameter errorMessage: message describing the error to the user
    func failedToCreateCard(errorMessage: String)
    
    /// Called when a person record is updated
    func didUpdatedCard(newRecord: CKRecord)
    
    /// Called when it was unable to update the person record
    ///
    /// - Parameter errorMessage: message describing the error to the user
    func failedToUpdateCard(errorMessage: String)
    
    
    //    func didDeleteRecord()
    //
    //    func failedToDelete(errorMessage: String)
    
}

class CardServices : NSObject {
    
    var delegate: CardServicesDelegate?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: Query operations
    func getAllCard() {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let predicate = NSPredicate(format: "number != '-1'")
        
        performQueryOperation(predicate: predicate)
    }
    
    func getCard(id: String) {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", id)
        
        performQueryOperation(predicate: predicate)
        
    }
    
    func getCard(user: User){
        
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let userReference = CKReference(record: user.record, action: .deleteSelf)
        let predicate = NSPredicate(format: "users CONTAINS %@", userReference)
        
        performQueryOperation(predicate: predicate)
    }
    
    func getCard(number: String) {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let predicate = NSPredicate(format: "number == %@", number)
        
        performQueryOperation(predicate: predicate)
    }
    
    func performQueryOperation(predicate: NSPredicate){
        var cards = [Card]()
        
        let query = CKQuery(recordType: "Card", predicate: predicate)
        
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.recordFetchedBlock = { record in
            let card = Card(withRecord: record)
            cards.append(card)
        }
        queryOp.queryCompletionBlock = { (cursor, error) in
            if error == nil {
                // TODO: usar cursor para carregar o resto dos dados
                print("Card fetched\n")
                DispatchQueue.main.async {
                    self.delegate!.didReceivedCard(card: cards)
                }
            }else {
                let errorInfo = ErrorController.shared.handleCKError(error: error as! CKError)
                
                if errorInfo.shouldRetry {
                    DispatchQueue.main.async {
                        self.performQueryOperation(predicate: predicate)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate!.failedToGetCard(errorMessage: errorInfo.message)
                    }
                }
            }
        }
        
        publicDB.add(queryOp)
    }
    
    
    // MARK: Create record operation
    func createCard(card: Card) {
        // TODO: verificar se ja nao existe usuario com esse nome
        
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        let userRecord = CKRecord(recordType: "Card")
        
        userRecord["id"] = card.id! as NSInteger as CKRecordValue
        userRecord["number"] = card.number! as NSString
        userRecord["found"] = card.valor as! CKRecordValue
        userRecord["countersign"] = card.contrasenha! as NSString
        userRecord["blocked"] = card.blocked! as NSInteger as CKRecordValue
        
        var users = [CKReference]()
        for user in card.users! {
            users.append(CKReference(record: user.record, action: .none))
        }
        userRecord["users"] = users as NSArray
        
        self.publicDB.save(userRecord){
            (record, error) in
            if error == nil {
                print("Card created\n")
                DispatchQueue.main.async {
                    self.delegate!.didCreatedCard(record: record!)
                }
            }else {
                let errorInfo = ErrorController.shared.handleCKError(error: error as! CKError)
                print("error")
                
                if errorInfo.shouldRetry {
                    DispatchQueue.main.async {
                        self.createCard(card: card)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate!.failedToCreateCard(errorMessage: errorInfo.message)
                    }
                }
            }
        }
        
    }
    
    // MARK: Update record operation
    func updateCard(card: Card) {
        guard delegate != nil else {
            print("There is no delegate\n")
            return
        }
        
        guard card.record != nil else {
            let message = "You must create the record before update it"
            print("Error: \(message)\n")
            DispatchQueue.main.async {
                self.delegate!.failedToUpdateCard(errorMessage: message)
            }
            return
        }
        let userRecord = CKRecord(recordType: "Card")
        
        userRecord["id"] = card.id! as NSInteger as CKRecordValue
        userRecord["number"] = card.number! as NSString
        userRecord["found"] = card.valor as! CKRecordValue
        userRecord["countersign"] = card.contrasenha! as NSString
        userRecord["blocked"] = card.blocked! as NSInteger as CKRecordValue
        
        saveUpdatedRecord(of: card)
    }
    
    private func saveUpdatedRecord(of card: Card){
        self.publicDB.save(card.record){
            (record, error) in
            if error == nil {
                print("Card updated\n")
                //UserInfoController.shared.refresh()
                DispatchQueue.main.async {
                    self.delegate!.didUpdatedCard(newRecord: record!)
                }
            } else {
                let errorInfo = ErrorController.shared.handleCKError(error: error as! CKError)
                
                if errorInfo.shouldRetry {
                    DispatchQueue.main.async {
                        self.saveUpdatedRecord(of: card)
                    }
                } else if errorInfo.concurrentAccessError {
                    let ckerror = error as! CKError
                    let serverRecord = ckerror.userInfo[CKRecordChangedErrorServerRecordKey] as! CKRecord
                    let clientRecord = ckerror.userInfo[CKRecordChangedErrorClientRecordKey] as! CKRecord
                    let ancestorRecord = ckerror.userInfo[CKRecordChangedErrorAncestorRecordKey] as! CKRecord
                    
                    card.record = serverRecord
                    self.updateCard(card: card)
                    
                }else {
                    DispatchQueue.main.async {
                        self.delegate!.failedToUpdateCard(errorMessage: errorInfo.message)
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

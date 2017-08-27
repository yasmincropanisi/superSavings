//
//  UserInfo.swift
//  superSavings
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 27/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import CloudKit

class UserInfo: NSObject {
    
    private(set) static var shared = UserInfo()
    var user: User?
    fileprivate var userId: String?
    fileprivate var userServices = UserServices()
    
    
    
    private override init() {
        super.init()
    }
    
    func refresh() {
        if user != nil {
            userServices.delegate = self
            userServices.getUser(id: user!.id!)
        }
    }
    func login(user: User) {
        self.user = user
        
    }
    
}

extension UserInfo: UserServicesDelegate {
    
    
    func didReceivedUser(user: [User]) {
        
        if user.count == 0 {
            
        } else {
            
            self.user = user.first
            
            
        }
    }
    
    func didUpdatedUser(newRecord: CKRecord) {
        print("atualizado")
    }
    
    func failedToUpdatePerson(errorMessage: String) {
        
    }
    
    func didCreatedUser(record: CKRecord) {
        // saves the created record in the UserDefaults
        user?.record = record
        
        UserInfo.shared.login(user: user!)
        
        /*if imageURL != nil{
         do {
         try? FileManager.default.removeItem(at: imageURL!)
         }
         }*/
        
        
        // login
        //DispatchQueue.main.async {
        //self.performSegue(withIdentifier: "SignUp", sender: self)
        // }
    }
    func failedToCreateUser(errorMessage: String) {
        
    }
    
}


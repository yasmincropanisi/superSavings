//
//  LoginViewController.swift
//  superSavings
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 27/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import CloudKit

class LoginViewController: UITabBarController {
    
    var user: User!
    var userServices = UserServices()
    var card:Card?
    var cardServices = CardServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardServices.delegate = self
        userServices.delegate = self
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.appBlue
        }
        
        userServices.getUser(name: "Ana Julia")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: person services delegate

extension LoginViewController: UserServicesDelegate {
    
    func didReceivedUser(user: [User]) {
        
        if user.count == 0 {
            
        } else {
            self.user = user.first
            cardServices.getCard(user: user.first!)
            
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
        let File = record["image"] as? CKAsset
        
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

// MARK: person services delegate

extension LoginViewController: CardServicesDelegate {
    
    func didReceivedCard(card: [Card]) {
        
        if card.count == 0 {
            userServices.createUser(user: user!)
            
            
        } else {
            //activityIndicator.stopAnimating()
            self.card = card.first
            print(card.first?.number)
            self.user.cards = [Card]()
            self.user.cards = card
            UserInfo.shared.login(user: user)
            
            
        }
    }
    
    func didUpdatedCard(newRecord: CKRecord) {
        
    }
    
    func failedToUpdateCard(errorMessage: String) {
            }
    
    func didCreatedCard(record: CKRecord) {
        // saves the created record in the UserDefaults
        card?.record = record
                // login
        //DispatchQueue.main.async {
        //self.performSegue(withIdentifier: "SignUp", sender: self)
        // }
    }
    func failedToCreateCard(errorMessage: String) {
        
    }
    
    func failedToGetCard(errorMessage: String) {
        
    }
    
    
}





//
//  ViewController.swift
//  TeenCard
//
//  Created by Gustavo De Mello Crivelli on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import UIKit
import CloudKit
import AgillitasClient

class AddUserViewController: UIViewController {
    
    var username : String?
    var userServices: UserServices!
    
    override func viewDidLoad() {
        
        userServices = UserServices()
        userServices.delegate = self
        
        let user = User(email: "bob.com")
        
        user.nome = "aaa"
        if let username = username {
            user.nome = username
        }
        user.email = "asdasda"
        user.id = 1
        user.sobrenome = "nasdadra"
        user.contato?.telResidencial = "19922"
        user.contato?.telCelular = "19922"

        user.cpf = "4222810"
        var date = Date()
        user.dataNascimento = date
        
        userServices.createUser(user: user)
    
        super.viewDidLoad()
        SwaggerClientAPI.customHeaders = ["client_id" : "6d44965e-5644-31f8-ae3c-47fb3fd9e6b5", "access_token" : "b9b9c58a-2cd2-353d-9371-bed3ce9e6394"]
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
// MARK: person services delegate

extension AddUserViewController: UserServicesDelegate {
    
    func didReceivedUser(users: [User]) {
        // if the email hasn't been registered yet
        // (if there is no person with this email in the database)
        if users.count == 0 {
            // self.errorView.isHidden = true
            
            
            // create a new person
            //person = Person(name: nameTextField.text!, email: emailTextField.text!, university: selectedUniversity, password: passwordTextField.text!.md5(), imageURL: imageURL)
            // saves the person in the database
            //userServices.createUser(user: user!)
            
            
        } else {
            //activityIndicator.stopAnimating()
            // shows error message informing that the email has already been registered
            //self.errorLabel.text! = "Email já cadastrado"
            //self.errorView.isHidden = false
            //self.scrollView.scrollRectToVisible(errorView.frame, animated: true)
        }
    }
    
    func didUpdatedUser(newRecord: CKRecord) {
        // save the updated record in the UserDefaults
        //editingPerson.record = newRecord
        //UserInfoController.shared.refresh()
        
        //activityIndicator.stopAnimating()
        
        // informs the user that the register has been updated
        //let alert = UIAlertController(title: "Perfil atualizado", message: "", preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
    }
    
    func failedToUpdatePerson(errorMessage: String) {
        // if there was an error updating the person, shows the error message to the user
        /*let alert = UIAlertController(title: "Erro ao atualizar pessoa", message: errorMessage, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)*/
    }
    
    func didCreatedUser(record: CKRecord) {
        // saves the created record in the UserDefaults
        //user?.record = record
        //let File = record["image"] as? CKAsset
        
        //UserInfoController.shared.login(user: person)
        
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

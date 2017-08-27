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

class ViewController: UIViewController {
    
    var user:User?
    var userServices = UserServices()
    var card:Card?
    var cardServices = CardServices()

    override func viewDidLoad() {
        
        user = User(email: "yasminnoguera")
        
        cardServices.delegate = self
        
        userServices.delegate = self
        
        user?.email = "oswaldo@gmail.com"
        user?.id = 1
        user?.nome = "Oswaldo"
        user?.sobrenome = "Nogueira"
        user?.contato?.telCelular = "19929292"
        user?.contato?.telResidencial = "19929292"

        user?.cpf = "44903899810"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: "01/08/1996")
        user?.dataNascimento = date
        
        //userServices.createUser(user: self.user!)
        
        userServices.getUser(name: (user?.nome)!)
        
       

        
        
        
        
        super.viewDidLoad()
        SwaggerClientAPI.customHeaders = ["client_id" : "6d44965e-5644-31f8-ae3c-47fb3fd9e6b5", "access_token" : "b9b9c58a-2cd2-353d-9371-bed3ce9e6394"]
                
        CartoesAPI.cartoesIdCartaoExtratoGet(idCartao: "3713100019350", dataInicial: Date(), dataFinal: Date()) { (response: ExtratoResponse?, error: Error?) in
            if let lista = response?.extrato {
                for detalhe in lista {
                    print(detalhe.dataHora ?? "VAZIO")
                }
            }
            else {
                print("SEUS BURRO TEM NADA AQUI")
            }
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
// MARK: person services delegate

extension ViewController: UserServicesDelegate {
    
    func didReceivedUser(user: [User]) {
        // if the email hasn't been registered yet
        // (if there is no person with this email in the database)
        print("fdffdf")
        if user.count == 0 {
           // self.errorView.isHidden = true
            
          
                // create a new person
                //person = Person(name: nameTextField.text!, email: emailTextField.text!, university: selectedUniversity, password: passwordTextField.text!.md5(), imageURL: imageURL)
                // saves the person in the database
                userServices.createUser(user: user.first!)
            
            
        } else {
            //activityIndicator.stopAnimating()
            // shows error message informing that the email has already been registered
            //self.errorLabel.text! = "Email já cadastrado"
            //self.errorView.isHidden = false
            //self.scrollView.scrollRectToVisible(errorView.frame, animated: true)
            card = Card(number: "teste")
            card?.blocked = 0
            card?.id = 2
            card?.contrasenha = "teste"
            card?.valor = 30
            card?.users = [User]()
            card?.users?.append(user.first!)
            //cardServices.createCard(card: card!)
            cardServices.getCard(user: user.first!)

            
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
        user?.record = record
        let File = record["image"] as? CKAsset
       
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

// MARK: person services delegate

extension ViewController: CardServicesDelegate {
    
    func didReceivedCard(card: [Card]) {
        // if the email hasn't been registered yet
        // (if there is no person with this email in the database)
        if card.count == 0 {
            // self.errorView.isHidden = true
            
            
            // create a new person
            //person = Person(name: nameTextField.text!, email: emailTextField.text!, university: selectedUniversity, password: passwordTextField.text!.md5(), imageURL: imageURL)
            // saves the person in the database
            userServices.createUser(user: user!)
            
            
        } else {
            //activityIndicator.stopAnimating()
            // shows error message informing that the email has already been registered
            //self.errorLabel.text! = "Email já cadastrado"
            //self.errorView.isHidden = false
            //self.scrollView.scrollRectToVisible(errorView.frame, animated: true)
            print(card.first?.number)
        }
    }
    
    func didUpdatedCard(newRecord: CKRecord) {
        // save the updated record in the UserDefaults
        //editingPerson.record = newRecord
        //UserInfoController.shared.refresh()
        
        //activityIndicator.stopAnimating()
        
        // informs the user that the register has been updated
        //let alert = UIAlertController(title: "Perfil atualizado", message: "", preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
    }
    
    func failedToUpdateCard(errorMessage: String) {
        // if there was an error updating the person, shows the error message to the user
        /*let alert = UIAlertController(title: "Erro ao atualizar pessoa", message: errorMessage, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)*/
    }
    
    func didCreatedCard(record: CKRecord) {
        // saves the created record in the UserDefaults
        card?.record = record
        let File = record["image"] as? CKAsset
        print("hey")
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
    func failedToCreateCard(errorMessage: String) {
        
    }
    
    func failedToGetCard(errorMessage: String) {
        
    }

    
}



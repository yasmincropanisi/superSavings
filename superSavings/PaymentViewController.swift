//
//  PaymentViewController.swift
//  superSavings
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 27/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var card: UILabel!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var monthYear: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
     var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor = UIColor.appBlue
        cardNumber.layer.masksToBounds = true
        cardNumber.layer.borderColor = myColor.cgColor
        cardNumber.layer.borderWidth = 2.0
        //cardNumber.

        self.user = UserInfo.shared.user
        
        card.text = self.user.cards?.first?.number

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

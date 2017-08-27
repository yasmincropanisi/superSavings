//
//  ExtratoViewController.swift
//  superSavings
//
//  Created by Lucas Santos on 27/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import AgillitasClient
class ExtratoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let cellIdentifier: String = ""
    var user: User!
    
    var responseExtrato = [DetalhamentoExtrato]()

    
    @IBOutlet weak var separadorDiv: UIView!
    @IBOutlet weak var segmentedControl: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        segmentedControl.tintColor = UIColor.appBlue
        separadorDiv.backgroundColor = UIColor.appBlue
        UIApplication.shared.statusBarStyle = .default
        // cor da status bar
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.appBlue
        }

        tableView.dataSource = self
        self.user = UserInfo.shared.user
  
        SwaggerClientAPI.customHeaders = ["client_id" : "6d44965e-5644-31f8-ae3c-47fb3fd9e6b5", "access_token" : "b9b9c58a-2cd2-353d-9371-bed3ce9e6394"]

        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        CartoesAPI.cartoesIdCartaoExtratoGet(idCartao: (self.user.cards?.first?.number)!, dataInicial: yesterday!, dataFinal: Date()) { (response: ExtratoResponse?, error: Error?) in
           
            self.responseExtrato = (response?.extrato)!
            
            self.tableView.reloadData()
            
            
        }
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

extension ExtratoViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (responseExtrato.count)
    }
    
    /*@IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExtratoCell
        let date = responseExtrato[indexPath.row].dataHora!
        let index = date.index(date.startIndex, offsetBy: 10)
        
        cell.dateLabel.text = date.substring(to: index)
        cell.detailLabel.text = (responseExtrato[indexPath.row].tipo)!
        cell.valueLabel.text = StringServices.MoneyFormatter(value: (responseExtrato[indexPath.row].valor)!)

        return cell
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}



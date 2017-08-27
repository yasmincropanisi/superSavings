//
//  MainViewController.swift
//  superSavings
//
//  Created by Lucas Santos on 26/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import AgillitasClient


class MainViewController: UIViewController {


    @IBInspectable var statusBarColor: UIColor = UIColor.blue

    @IBOutlet weak var askForMoneyBtn: UIButton!
    @IBOutlet weak var currentValueOnCard: UILabel!
    @IBOutlet weak var totalForPieChart: UILabel!
    @IBOutlet weak var graphicView: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    var user:User?
    
    fileprivate var myFakeData: [FakeDataForSpendsCategorization] = [FakeDataForSpendsCategorization]()
    fileprivate let cellIdentifier = "spentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = UserInfo.shared.user

        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.appBlue
        }
        
        //Button configs
        askForMoneyBtn.layer.cornerRadius = askForMoneyBtn.frame.height/3
        askForMoneyBtn.layer.masksToBounds = true
        
        //Create some fake data
        myFakeData = [FakeDataForSpendsCategorization(color: UIColor.chartBlue, percentage: 0.2, totalValue: 100.0, name: "Alimento" ), FakeDataForSpendsCategorization(color: UIColor.chartGreen, percentage: 0.5, totalValue: 300.0, name: "Entretenimento"), FakeDataForSpendsCategorization(color: UIColor.chartPurple, percentage: 0.3, totalValue: 50.0, name: "Saúde")]
        
        
        var totalValue: Double = 0
        for i in 0..<myFakeData.count{
            totalValue += myFakeData[i].totalValue
        }
        
        for i in 0..<myFakeData.count{
            myFakeData[i].percentage = myFakeData[i].totalValue / totalValue
        }
        
        
        graphicView.dataToDisplay = myFakeData
        
       
        totalForPieChart.text = StringServices.MoneyFormatter(value: totalValue)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCard () -> Bool {
        var isRegistered = false
        let novoCartao = SetNovoCartao()
        novoCartao.cartao = self.user?.cards?.first
        novoCartao.cartao?.portador = self.user
        
        CartoesAPI.cartoesPost(cartao: novoCartao) { (error) in
         if (error != nil)
         {
            isRegistered = false
         } else {
         isRegistered = true
         }
        }
        return isRegistered
        
    }
    
    func updateAmmount() -> Bool {
    
    var setSaldo = SetSaldo()
    var saldo = SetSaldoValor()
    saldo.valor = 800
    setSaldo.saldo = saldo
    var isUpdated = false
    
    CartoesAPI.cartoesIdCartaoSaldoPut(idCartao: (self.user?.cards?.first?.idCartao)!, saldo: setSaldo) {  (error) in
     
        if (error == nil) {
            isUpdated = true
        } else {
            isUpdated = true
        }
        
    }
    return isUpdated
    }
    

}

extension MainViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return myFakeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! specifcSpendCell
        
        cell.nameLabel.text = myFakeData[indexPath.row].name
        cell.valueLabel.text = StringServices.MoneyFormatter(value: myFakeData[indexPath.row].totalValue)
        cell.colorView.backgroundColor = myFakeData[indexPath.row].color
        
        return cell
        
    }
    
}

extension MainViewController: UITableViewDelegate{
    
}

struct FakeDataForSpendsCategorization{
    var color: UIColor
    var percentage: Double
    var totalValue: Double
    var name: String
}

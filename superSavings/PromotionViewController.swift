//
//  PromotionViewController.swift
//  superSavings
//
//  Created by Juliane Vianna on 27/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController {
   
    @IBOutlet weak var promotionColletionView: UICollectionView!

    var products: [FakeDataForPromotion] = [FakeDataForPromotion]()
    
    fileprivate let cellIdentifier = "PromotionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.appBlue
        }

        promotionColletionView.dataSource = self
        
        products = [FakeDataForPromotion(productName: "The Elder Scrolls V: Skyrim Special Edition", companyName: "Steam", oldPrice: 169.90, promotionalPrice: 84.95, productImage: UIImage(named:"header")!),
                    FakeDataForPromotion(productName: "The Elder Scrolls V: Skyrim Special Edition", companyName: "Steam", oldPrice: 169.90, promotionalPrice: 84.95, productImage: UIImage(named:"header")!)]
        
        
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

extension PromotionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return products.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let myCell: PromotionCollectionViewCell = promotionColletionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PromotionCollectionViewCell
        
        myCell.fotoPropaganda.image = products[indexPath.row].productImage
        myCell.nomeLoja.text = products[indexPath.row].companyName
        myCell.nomeProduto.text = products[indexPath.row].productName
        myCell.valorAntigo.text = StringServices.MoneyFormatter(value: products[indexPath.row].oldPrice)
        myCell.valorDesconto.text = StringServices.MoneyFormatter(value: products[indexPath.row].promotionalPrice)

        return myCell
    }
    
}


struct FakeDataForPromotion{
    var productName: String
    var companyName: String
    var oldPrice: Double
    var promotionalPrice: Double
    var productImage: UIImage
}

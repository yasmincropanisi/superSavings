//
//  ViewController.swift
//  superSavings
//
//  Created by Lucas Santos on 26/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class DreamViewController: UIViewController {

    @IBOutlet weak var dreamImageView: UIImageView!
    var dreamImageRingView: DreamView = DreamView()
    
    fileprivate var dreamData: FakeDataForDream = FakeDataForDream(saved: 675.50, total: 1500.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.appBlue
        }
        
        dreamImageView.layer.cornerRadius = dreamImageView.frame.size.width/2
        dreamImageView.layer.masksToBounds = true
        //dreamImage.total = dreamData.total
        //dreamImage.current = dreamData.saved
        
        //create a frame 20% larger
        let newFrame = CGRect(origin: dreamImageView.frame.origin, size: CGSize(width: dreamImageView.frame.size.width * 1.3, height: dreamImageView.frame.size.height * 1.3))
        
        dreamImageRingView = DreamView(frame: newFrame)
        
        dreamImageRingView.center = dreamImageView.center
        
        dreamImageRingView.backgroundColor = UIColor.clear
        self.view.addSubview(dreamImageRingView)
        dreamImageRingView.current = dreamData.saved
        dreamImageRingView.total = dreamData.total
        dreamImageRingView.calculateProportion()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//Data for testing, should be replaced with actual data
struct FakeDataForDream{
    var saved: Float
    var total: Float
}

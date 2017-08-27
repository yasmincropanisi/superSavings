//
//  RequestCell.swift
//  TeenCard
//
//  Created by Gustavo De Mello Crivelli on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import UIKit

protocol RequestDelegate {
    func approveRequest(requestId: Int)
    
    func denyRequest(requestId: Int)
}

class RequestCell : UITableViewCell {

    let delegate : RequestDelegate! = nil
    var requestId : Int = -1
    
    @IBOutlet weak var amountRequestedLabel: UILabel!
    
    @IBOutlet weak var approveButton: UIButton!
    
    @IBOutlet weak var denyButton: UIButton!
    
    @IBOutlet weak var requestByUserLabel: UILabel!
    
    @IBAction func approveTapped(_ sender: Any) {
        delegate.approveRequest(requestId: requestId)
    }
    
    @IBAction func denyTapped(_ sender: Any) {
        delegate.denyRequest(requestId: requestId)
    }
}

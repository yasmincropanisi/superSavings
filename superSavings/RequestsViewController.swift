//
//  RequestsViewController.swift
//  TeenCard
//
//  Created by Gustavo De Mello Crivelli on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import CloudKit
import UIKit
import UserNotifications

class RequestsViewController : UIViewController {
    
    @IBOutlet weak var requestTableView: UITableView!
    
    var requests : [Request]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // TODO: CHANGE INTO TRUE CARD REFERENCE LIST
        let referenceList = [CKReference]()
        
        var subPredicates : [NSPredicate] = []
        for reference in referenceList {
            let subPredicate = NSPredicate(format: "id_card == %@", reference)
            subPredicates.append(subPredicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        
        RetrievalServices.retrieveRecord(with: compoundPredicate, recordType: "Request", completion: { [unowned self] (requests) in
            if let requestList = requests {
                self.requests = self.recordListToRequestList(requestList as! [CKRecord])
                
                DispatchQueue.main.async { [unowned self] in
                    self.requestTableView.reloadData()
                }
            }
            else {
                //TODO: no requests found
            }
        })
    }
    
    func recordListToRequestList(_ records: [CKRecord]?) -> [Request]? {
        
        var requestList = [Request]()
        
        if let recordList = records {
            for record in recordList {
                let request = Request(with: record)
                requestList.append(request)
            }
        }
        return requestList
    }
//                let predicate = NSPredicate(format: "recordName == %@", ((record["id_requester"]) as! CKReference).recordID.recordName)
//                RetrievalServices.retrieveRecord(with: predicate, recordType: "User", completion: { (requesf) in
//                    
//                })
//                
//            }
//        }
//    }
    
    func registerForRequests(with cardRecord: CKRecord) {
        
        let publicDB = CKContainer.default().publicCloudDatabase
        
        let cardReferenceToMatch = CKReference(record: cardRecord, action: CKReferenceAction.deleteSelf)
        let predicate = NSPredicate(format: "id_card == %@", cardReferenceToMatch)
        
        let subscription = CKQuerySubscription(recordType: "Request",
                                               predicate: predicate,
                                               options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        
        notificationInfo.alertBody = "Você possui um novo pedido de pagamento!"
        notificationInfo.shouldBadge = true
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription,
                              completionHandler: ({returnRecord, error in
                                if let err = error {
                                    print("subscription failed %@",
                                          err.localizedDescription)
                                } else {
                                    DispatchQueue.main.async() {
                                        print("Subscription posted!")
//                                        self.notifyUser("Success",
//                                                        message: "Subscription set up successfully")
                                    }
                                }
                              }))
    }
}

extension RequestsViewController:UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestCell
        
        let request = requests?[indexPath.row]
        
        cell.requestId = (request?.requestID)!
        cell.amountRequestedLabel.text = String(format: "R$%.02f", (request?.requestValue)!)
        cell.requestByUserLabel.text = "João"
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests?.count ?? 0
    }
}

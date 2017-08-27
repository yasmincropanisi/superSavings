//
//  Request.swift
//  TeenCard
//
//  Created by Gustavo De Mello Crivelli on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import CloudKit

class Request {
    
    var record : CKRecord!
    var requestID: Int
    var cardID : CKReference
    var requesterID : CKReference
    var requesterName : String!
    var requestValue : Double
    var status : Int
    
    init(requestID: Int, cardID : CKReference, requesterID : CKReference, value: Double, status : Int) {
        self.requestID = requestID
        self.cardID = cardID
        self.requesterID = requesterID
        self.requestValue = value
        self.status = status
        
        self.record = CKRecord(recordType: "Request")
        self.record["id"] = requestID as CKRecordValue
        self.record["id_card"] = cardID
        self.record["id_requester"] = requesterID
        self.record["status"] = status as CKRecordValue
        self.record["value"] = value as CKRecordValue
    }

    init(with record: CKRecord) {
        self.record = record
        self.requestID = record["id"] as! Int
        self.cardID = record["id_card"] as! CKReference
        self.requesterID = record["id_requester"] as! CKReference
        self.requestValue = record["value"] as! Double
        self.status = record["status"] as! Int
    }
    
}

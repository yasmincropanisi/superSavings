//
//  RetrievalServices.swift
//  TeenCard
//
//  Created by Gustavo De Mello Crivelli on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import CloudKit

class RetrievalServices {
    
    // Retrieves record asynchronously via predicate
    static func retrieveRecord(with predicate: NSPredicate, recordType: String, completion: @escaping ([CKRecord]?) -> Void) {
        
        let publicDB = CKContainer.default().publicCloudDatabase
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: {
            results, error in
            if error == nil && results?.count == 1{
                print("Records fetched\n")
                DispatchQueue.main.async {
                    completion(results)
                }
            }
        })
    }
}

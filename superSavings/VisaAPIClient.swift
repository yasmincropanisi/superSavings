//
//  VisaAPIClient.swift
//  TeenCard
//
//  Created by Gustavo De Mello Crivelli on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation

class VisaAPIClient {
    
    func getXPayToken(body : JSONSerialization) -> String {
        
        let sharedSecret = "9S4RL+Yo7B}AtMqRZvut0DE1sd#LOLVc$ykJZuOk"
        
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let resource_url = "payments/v1/authorizations"
        let query = "apikey=VO2Z61QLEZ647OBIXVYK212TLvVAySl_d9WdrakGGWy7fpmmk"
        let payload = ""//body
        
        let beforeToken : String = timestamp + resource_url + query + payload
        let HMACDigest = beforeToken.hmac(algorithm: CryptoAlgorithm.SHA256, key: sharedSecret)
        
        let XPayToken : String = "xv2:" + timestamp + ":" + HMACDigest
        return XPayToken
    }
    
}

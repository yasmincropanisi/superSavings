//
//  StringServices.swift
//  superSavings
//
//  Created by Lucas Santos on 26/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation

class StringServices{
    
    class func MoneyFormatter(value: Double) -> String{
        

        
        return String(format: "R$ %.02f", locale: Locale.init(identifier: "br"), arguments: [value])
        
    }
    
    
}

//
//  PieChartView.swift
//  superSavings
//
//  Created by Lucas Santos on 26/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class PieChartView: UIView {

    var dataToDisplay: [FakeDataForSpendsCategorization] = [FakeDataForSpendsCategorization]()

    override func draw(_ rect: CGRect) {
        
        let _: CGContext! = UIGraphicsGetCurrentContext()
        
        let rectCenter = CGPoint(x: rect.origin.x + rect.size.width/2, y: rect.origin.y + rect.size.height/2)
        

   //     var paths: [UIBezierPath] = [UIBezierPath]()
        
   //     var i = 0
        var lastEndAngle: CGFloat = CGFloat(0)
        for i in 0..<dataToDisplay.count{
            
            let drawPath = UIBezierPath(arcCenter: rectCenter, radius: CGFloat(CGFloat(rect.size.width/2)), startAngle: lastEndAngle, endAngle: (2 * CGFloat.pi) * CGFloat(dataToDisplay[i].percentage) + (lastEndAngle), clockwise: true)
            drawPath.addLine(to: rectCenter)
            drawPath.close()
            
            dataToDisplay[i].color.setFill()
            drawPath.fill()
            
            lastEndAngle = (2 * CGFloat.pi) * CGFloat(dataToDisplay[i].percentage) + (lastEndAngle)
        }

        
        
        
    }

}


//
//  DreamView.swift
//  superSavings
//
//  Created by Lucas Santos on 26/08/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class DreamView: UIView {

    var total: Float = 0
    var current: Float = 0
    
    var proportion: Float = 0
    
    @IBInspectable var colorFill: UIColor = UIColor.ringGreen
    @IBInspectable var colorVoid: UIColor = .clear

    public func calculateProportion(){
        proportion = current/total
    }
    
    override func draw(_ rect: CGRect) {

        let _: CGContext! = UIGraphicsGetCurrentContext()
        
        
        let rectCenter = CGPoint(x: rect.origin.x + rect.size.width/2, y: rect.origin.y + rect.size.height/2)
        
        let outerCirclePath = UIBezierPath(arcCenter: rectCenter, radius: CGFloat(rect.size.width/2), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        outerCirclePath.addClip()
        
        colorVoid.setFill()
        outerCirclePath.fill()
        
        print(proportion)
        
        let pathComplete = UIBezierPath(arcCenter: rectCenter, radius: CGFloat(CGFloat(rect.size.width/2)), startAngle: 3/2 * CGFloat.pi, endAngle: (2 * CGFloat.pi) * CGFloat(proportion) + (3/2 * CGFloat.pi), clockwise: true)
        
        pathComplete.addLine(to: rectCenter)
        pathComplete.close()
        
        
        colorFill.setFill()
        pathComplete.fill()
        //AQUI O INNER
        let innerCirclePath = UIBezierPath(arcCenter: rectCenter, radius: CGFloat(rect.size.width/2.5), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        innerCirclePath.addClip()
        
        innerCirclePath.fill(with: .clear, alpha: 0)
    }
    
    

}

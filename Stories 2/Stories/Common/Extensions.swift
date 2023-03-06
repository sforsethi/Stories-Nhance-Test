//
//  Extensions.swift
//  Stories
//
//  Created by Admin on 01/03/23.
//

import Foundation
import UIKit

extension UIView {
    
    public func addBorderGradient(to view: UIView,lineWidth: CGFloat, stories: Int) { //, lineDashPattern: [NSNumber]) {
        self.layer.cornerRadius = view.bounds.size.height / 2.0
        self.clipsToBounds = true
        
        let firstColor = UIColor(red: 199/255, green: 255/255, blue: 211/255, alpha: 1)
        let secondColor = UIColor(red: 0, green: 123/255, blue: 161/255, alpha: 1)
        let thirdColor = UIColor(red: 59/255, green: 88/255, blue: 161/255, alpha: 1)
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
    
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(arcCenter: CGPoint(x: view.bounds.height/2, y: view.bounds.height/2), radius: view.bounds.height/2, startAngle: CGFloat(0), endAngle:CGFloat(CGFloat.pi * 2), clockwise: true).cgPath
        
        var storySegments = 1/CGFloat(stories)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shape.path
        shapeLayer.strokeStart = storySegments * CGFloat(stories)
        
        let gapSize: CGFloat = 0.05
        shapeLayer.strokeEnd = shapeLayer.strokeStart + storySegments - gapSize
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.systemRed.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
       
        gradient.mask = shape
        self.layer.addSublayer(gradient)
    }
    
    func addBorder() {
        let grayColor = UIColor(red: 191/255, green: 199/255, blue: 199/255, alpha: 1)
        self.layer.borderWidth = 3
        self.layer.borderColor = grayColor.cgColor
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }
}

extension Int {
    var toFloat: CGFloat {
        return CGFloat(self)
    }
}


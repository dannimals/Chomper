//
//  UIView+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//


extension UIView {
    
    public func setShadow(color: CGColor = UIColor.lightGrayColor().CGColor, opacity: Float = 0.75, height: CGFloat = 3.5, shadowRect: CGRect? = nil) {
        let viewBounds = layer.bounds
        let shadowFrame = CGRect(x: viewBounds.origin.x, y: viewBounds.maxY, width: viewBounds.width, height: height)
        
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowRect ?? shadowFrame).CGPath
        layer.shadowPath = shadowPath
        layer.shadowColor = color
        layer.shadowOpacity = opacity
    }
   
}

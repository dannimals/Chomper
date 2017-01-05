//
//  CALayer+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 1/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

extension CALayer {
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

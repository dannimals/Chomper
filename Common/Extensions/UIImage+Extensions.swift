//
//  UIImage+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/5/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

extension UIImage {
    
    public static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
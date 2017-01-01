//
//  UIImage+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/5/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

extension UIImage {
    
    public static func fromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

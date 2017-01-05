//
//  UIView+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//


extension UIView {
    
    public func setShadow(_ color: CGColor = UIColor.softGrey().cgColor, opacity: Float = 0.75, height: CGFloat = 3.5, shadowRect: CGRect? = nil) {
        let viewBounds = layer.bounds
        let shadowFrame = CGRect(x: viewBounds.origin.x, y: viewBounds.maxY, width: viewBounds.width, height: height)
        
        let shadowPath: CGPath = UIBezierPath(rect: shadowRect ?? shadowFrame).cgPath
        layer.shadowPath = shadowPath
        layer.shadowColor = color
        layer.shadowOpacity = opacity
    }
    
    public class func loadNibWithName<T: UIView>(_ viewType: T.Type) -> T {
        let namedClassName = String(describing: viewType)
        let className = namedClassName.components(separatedBy: ".").first!
        return UINib(nibName: className, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
   
}

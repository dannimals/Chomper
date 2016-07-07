//
//  UIFont+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 7/7/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//


extension UIFont {
    /*
        Returns a UIFont of the specified style and weight:
            - parameter style:
                Possible values:
                    -h1
                    -h2
                    -h3
                    -h4
                    -h5
                    -p
                    -p-small
                    -smallest
    */
    
    public static func chomperFontForTextStye(style: String, weight: CGFloat? = nil, maxDynamicTypeRatio: CGFloat = 1.5, minDynamicTypeRatio: CGFloat = 0.5) -> UIFont {
        var pointSize: CGFloat
        var fontWeight: CGFloat? = nil
        
        switch style {
            case "h1":
                pointSize = 26.0
                fontWeight = UIFontWeightRegular
            case "h2":
                pointSize = 20.0
                fontWeight = UIFontWeightSemibold
            case "h3":
                pointSize = 18.0
                fontWeight = UIFontWeightSemibold
            case "h4":
                pointSize = 16.0
                fontWeight = UIFontWeightSemibold
            case "h5":
                pointSize = 14.0
                fontWeight = UIFontWeightSemibold
            case "p":
                pointSize = 16.0
                fontWeight = UIFontWeightRegular
            case "p small":
                pointSize = 14.0
                fontWeight = UIFontWeightRegular
            case "smallest":
                pointSize = 12.0
                fontWeight = UIFontWeightRegular
            default:
                pointSize = 14.0
                fontWeight = UIFontWeightRegular
        }
        
        //
        // If the user has their content size set higher or lower than normal,
        // determine the factor to increase/decrease font by.
        // Min factor 0.5, max 1.5
        
        var pointSizeRatio = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize / 17.0
        pointSizeRatio = pointSizeRatio > maxDynamicTypeRatio ? maxDynamicTypeRatio : pointSizeRatio < minDynamicTypeRatio ? minDynamicTypeRatio : pointSizeRatio
        pointSize = pointSize * pointSizeRatio

        
        //
        // If weight was passed in, use value
        
        if weight != nil {
            fontWeight = weight
        }
        
        return UIFont.systemFontOfSize(pointSize, weight: fontWeight!)
    }
}
//
//  BaseNavigationController.swift
//  Chomper
//
//  Created by Danning Ge on 7/7/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import UIKit

//
// Class for overriding elements in UINavigationController for Chomper customization

class BaseNavigationController: UINavigationController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage.fromColor(UIColor.darkOrange()), for: .default)
    }
}

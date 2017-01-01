//
//  BaseViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/17/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

//
// Base UIViewController class that every view controller should inherit from
// Used only for setting shared UI settings

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

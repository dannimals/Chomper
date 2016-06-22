//
//  MyPlacesViewController.swift
//  Chomper
//
//  Created by Danning Ge on 5/16/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import UIKit
import WebServices

class MyPlacesViewController: UIViewController, BaseViewControllerProtocol {
    
    override init(nibName: String?, bundle nibBundle: NSBundle?) {
        super.init(nibName: nibName, bundle: nibBundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
    }


}

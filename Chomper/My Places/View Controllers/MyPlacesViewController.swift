//
//  MyPlacesViewController.swift
//  Chomper
//
//  Created by Danning Ge on 5/16/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import WebServices

class MyPlacesViewController: UIViewController, BaseViewControllerProtocol {
    
    private var viewModeControl: UISegmentedControl!
    private var collectionViewController: UICollectionViewController!
    private var tableViewController: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

        //
        // Set up viewModeControl
        
        let viewModeObjects = [NSLocalizedString("Tile", comment: "Collection view"), NSLocalizedString("List", comment: "Table view")]
        viewModeControl = UISegmentedControl(items: viewModeObjects)
        view.addSubview(viewModeControl)
        var frame = viewModeControl.frame
        frame.size = CGSize(width: 150, height: frame.size.height)
        viewModeControl.frame = frame
        viewModeControl.selectedSegmentIndex = 0
        navigationItem.titleView = viewModeControl
        
        //
        // Set up view controllers
        
        
        
    
    }


}

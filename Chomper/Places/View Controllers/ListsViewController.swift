//
//  MyPlacesViewController.swift
//  Chomper
//
//  Created by Danning Ge on 5/16/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import WebServices

class ListsViewController: BaseViewController {
    
    private var viewModeControl: UISegmentedControl!
    private var tileViewController: ListsTileViewController!
    private var listViewController: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("+", comment: "Add"), style: .Plain, target: self, action: #selector(createNewList))

        //
        // Set up segmented control as titleView
        
        let viewModeObjects = [NSLocalizedString("Tile", comment: "Collection view"), NSLocalizedString("List", comment: "Table view")]
        viewModeControl = UISegmentedControl(items: viewModeObjects)
        viewModeControl.addTarget(self, action: #selector(handleViewMode(_:)), forControlEvents: .ValueChanged)
        view.addSubview(viewModeControl)
        var frame = viewModeControl.frame
        frame.size = CGSize(width: 150, height: frame.size.height)
        viewModeControl.frame = frame
        viewModeControl.selectedSegmentIndex = 0
        navigationItem.titleView = viewModeControl
        
        
        //
        // Set up child view controllers
        
        createListViewController()
        createTileViewController()
        
    }
    
    // MARK: - Helpers
    
    func createNewList() {
        let vc = CreateListViewController()
        vc.modalTransitionStyle = .CrossDissolve
        vc.modalPresentationStyle = .OverCurrentContext
        vc.modalPresentationCapturesStatusBarAppearance = true
        presentViewController(vc, animated: true, completion: nil)
    }
    
    private func createTileViewController() {
        let layout = ListsCollectionViewLayout()
        tileViewController = ListsTileViewController(collectionViewLayout: layout)
        
        addChildViewController(tileViewController)
        view.addSubview(tileViewController.view)
        tileViewController.didMoveToParentViewController(self)
        tileViewController.collectionView?.scrollsToTop = false
    }
    
    private func createListViewController() {
        listViewController = ListsTableViewController()
        addChildViewController(listViewController)
        view.addSubview(listViewController.view)
        listViewController.didMoveToParentViewController(self)
    }
    
    // MARK: - Handlers
    
    func handleViewMode(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listViewController.view.removeFromSuperview()
            view.addSubview(tileViewController.view)
        } else {
            tileViewController.view.removeFromSuperview()
            view.addSubview(listViewController.view)
        }
    }

}

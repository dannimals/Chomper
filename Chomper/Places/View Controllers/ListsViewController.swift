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
    private var listViewController: ListsTableViewController!
    private var scrollView: UIScrollView!
    private var toggle: ToggleControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(createNewList))
        
        //
        // Set up toggle and parent scrollView
        
        createToggle()
        createScrollView()
        
        //
        // Set up child view controllers
        
        createListViewController()
        createTileViewController()
        
        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "toggle": toggle,
            "scrollView": scrollView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[toggle]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide][toggle(40)]-(-1)-[scrollView]|",
            options: [],
            metrics: nil,
            views: views)
        )

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: WTF are autoresizing masks??!!!!

        var scrollBounds = scrollView.bounds
        scrollBounds.origin.x = scrollBounds.width
        scrollView.contentSize = CGSizeMake(2 * scrollBounds.width, scrollBounds.height)
        tileViewController.view.frame = CGRect(origin: CGPointZero, size: scrollView.bounds.size)
        listViewController.view.frame = scrollBounds
    }
    
    // MARK: - Helpers
    
    func createToggle() {
        toggle = ToggleControl(titles: [NSLocalizedString("Tile", comment: "tile"), NSLocalizedString("List", comment: "list")])
        toggle.setShadow()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggle)
    }
    
    func createScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.pagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.directionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
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
        tileViewController.didMoveToParentViewController(self)
        scrollView.addSubview(tileViewController.view)
        
        tileViewController.collectionView?.scrollsToTop = false
    }
    
    private func createListViewController() {
        listViewController = ListsTableViewController()
        addChildViewController(listViewController)
        listViewController.didMoveToParentViewController(self)
        scrollView.addSubview(listViewController.view)
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

extension ListsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x < view.bounds.width {
            toggle.setSelectedIndex(0, animated: true)
        } else {
            toggle.setSelectedIndex(1, animated: true)
        }
    }
}

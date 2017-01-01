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
    
    fileprivate var viewModeControl: UISegmentedControl!
    fileprivate var tileViewController: ListsTileViewController!
    fileprivate var listViewController: ListsTableViewController!
    fileprivate var scrollView: UIScrollView!
    fileprivate var toggle: ListsToggleControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewList))
        
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
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[toggle]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|",
            options: [],
            metrics: nil,
            views: views)
        )
    
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[topLayoutGuide][toggle(50)]-(4)-[scrollView]|",
            options: [],
            metrics: nil,
            views: views)
        )

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var scrollBounds = scrollView.bounds
        scrollBounds.origin.x = scrollBounds.width
        scrollView.contentSize = CGSize(width: 2 * scrollBounds.width, height: scrollBounds.height)
        tileViewController.view.frame = CGRect(origin: CGPoint.zero, size: scrollView.bounds.size)
        listViewController.view.frame = scrollBounds
        
        toggle.setShadow()
    }
    
    // MARK: - Helpers
    
    func createToggle() {
        toggle = ListsToggleControl(titles: [NSLocalizedString("Tile", comment: "tile"), NSLocalizedString("List", comment: "list")])
        toggle.labelTappedAction = { [unowned self] (index) in
            self.toggleViews(index)
        }
        toggle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggle)
    }
    
    func toggleViews(_ index: Int) {
        let contentOffsetY = self.scrollView.contentOffset.y
        if index == 0 {
            self.scrollView.contentOffset = CGPoint(x: 0, y: contentOffsetY)
        } else {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.width, y: contentOffsetY)
        }
    }
    
    func createScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func createNewList() {
        let vc = CreateListViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationCapturesStatusBarAppearance = true
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func createTileViewController() {
        let layout = ListsCollectionViewLayout()
        tileViewController = ListsTileViewController(collectionViewLayout: layout)
        addChildViewController(tileViewController)
        tileViewController.didMove(toParentViewController: self)
        scrollView.addSubview(tileViewController.view)
        
        tileViewController.collectionView?.scrollsToTop = false
    }
    
    fileprivate func createListViewController() {
        listViewController = ListsTableViewController()
        addChildViewController(listViewController)
        listViewController.didMove(toParentViewController: self)
        scrollView.addSubview(listViewController.view)
    }
}

extension ListsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        toggle.scrollOffSetX(scrollView.contentOffset.x)
        if scrollView.contentOffset.x < view.bounds.width {
            toggle.setSelectedIndex(0)
        } else {
            toggle.setSelectedIndex(1)
        }
    }
}

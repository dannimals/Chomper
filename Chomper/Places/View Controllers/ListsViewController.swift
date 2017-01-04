//
//  MyPlacesViewController.swift
//  Chomper
//
//  Created by Danning Ge on 5/16/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import WebServices

class ListsViewController: UIViewController {
    
    fileprivate var toggle: ListsToggleControl!

    private var listViewController: ListsTableViewController!
    private var scrollView: UIScrollView!
    private var tileViewController: ListsTileViewController!
    private var viewModeControl: UISegmentedControl!
    private var actionToggle: ActionToggleControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //
        // Set up toggle and parent scrollView
        
        createToggle()
        createScrollView()
        
        //
        // Set up child view controllers
        
        createListViewController()
        createTileViewController()
        createActionControl()
        
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
    
    func createActionControl() {
        actionToggle = ActionToggleControl(titles: [NSAttributedString(string: "+"), NSAttributedString(string: "Map")], showUnderlineView: false)
        actionToggle.labelTappedAction = { [weak self] index in
            self?.handleActionForIndex(index: index)
        }
        view.addSubview(actionToggle)
        NSLayoutConstraint.useAndActivateConstraints([
            actionToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionToggle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController!.tabBar.bounds.height + 20)),
            actionToggle.widthAnchor.constraint(equalToConstant: 100),
            actionToggle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func handleActionForIndex(index: Int) {
        if index == 0 {
            let vc = CreateListViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationCapturesStatusBarAppearance = true
            present(vc, animated: true, completion: nil)
        }
    }
    
    func createToggle() {
        toggle = ListsToggleControl(titles: [NSAttributedString(string: NSLocalizedString("Tile", comment: "Tile")), NSAttributedString(string: NSLocalizedString("List", comment: "List"))])
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
    
    private func createTileViewController() {
        let layout = ListsCollectionViewLayout()
        tileViewController = ListsTileViewController(collectionViewLayout: layout)
        addChildViewController(tileViewController)
        tileViewController.didMove(toParentViewController: self)
        scrollView.addSubview(tileViewController.view)
        
        tileViewController.collectionView?.scrollsToTop = false
    }
    
    private func createListViewController() {
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

class ActionToggleControl: ToggleControl {
    var labelTappedAction: ((_ index: Int) -> Void)?
    
    override func labelTappedWithIndex(_ index: Int) {
        labelTappedAction?(index)
    }
    
    required init(titles: [NSAttributedString], showUnderlineView show: Bool) {
        super.init(titles: titles, showUnderlineView: show)
        
        font = UIFont.chomperFontForTextStyle("p small")
        unselectedColor = UIColor.white
        selectedColor = UIColor.white
        layer.cornerRadius = 20
        backgroundColor = UIColor.orange.withAlphaComponent(0.8)
        layer.borderColor = UIColor.orange.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
    fileprivate var toggle: ListsToggleControl!
    private var listViewController: ListsTableViewController!
    private var mapViewController: MapPlacesViewController!
    private var scrollView: UIScrollView!
    private var tileViewController: ListsTileViewController!
    private var viewModeControl: UISegmentedControl!
    private var actionToggle: CustomToggleControl!
    private var mapView: UIView!
    private var containerStackview: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //
        // Set up toggle and parent scrollView
        
        containerStackview = UIStackView()
        containerStackview.axis = .vertical
        containerStackview.spacing = 5
        containerStackview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerStackview)

        createToggle()
        createScrollView()
        
        //
        // Set up child view controllers
        
        createMapViewController()
        createListViewController()
        createTileViewController()
        createActionControl()
        
        containerStackview.sizeToFit()
        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "containerStackview": containerStackview,
            "scrollView": scrollView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerStackview]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|",
            options: [],
            metrics: nil,
            views: views)
        )
    
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[topLayoutGuide][containerStackview]-(4)-[scrollView]|",
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

    private func createActionControl() {
        let add = NSAttributedString(string: "+", attributes: [NSFontAttributeName: UIFont.chomperFontForTextStyle("h1")])
        let map = NSAttributedString(string: "Map", attributes: [NSFontAttributeName: UIFont.chomperFontForTextStyle("p")])
        actionToggle = CustomToggleControl(titles: [add, map])
        view.addSubview(actionToggle)
        actionToggle.selectedIndex = { [weak self] index in
            self?.handleActionForIndex(index: index)
        }

        NSLayoutConstraint.useAndActivateConstraints([
            actionToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionToggle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController!.tabBar.bounds.height + 20)),
            actionToggle.widthAnchor.constraint(equalToConstant: 120),
            actionToggle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func handleActionForIndex(index: Int) {
        if index == 0 {
            let vc = CreateListViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationCapturesStatusBarAppearance = true
            present(vc, animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3) {
                let isHidden = self.mapView.isHidden
                let title: NSAttributedString
                if isHidden {
                    title = NSAttributedString(string: "Hide", attributes: [NSFontAttributeName: UIFont.chomperFontForTextStyle("p")])
                } else {
                    title = NSAttributedString(string: "Map", attributes: [NSFontAttributeName: UIFont.chomperFontForTextStyle("p")])
                }
                self.mapView.isHidden = !isHidden
                self.actionToggle.setTitleForIndex(title: title, forIndex: 1)
            }
        }
    }
    
    private func createToggle() {
        let tile = NSMutableAttributedString(string: "Tile")
//        let tileIcon = NSTextAttachment()
//        tileIcon.image = UIImage(named: "TileIcon")
//        let tileIconString = NSAttributedString(attachment: tileIcon)
//        tile.append(tileIconString)
        toggle = ListsToggleControl(titles: [tile, NSAttributedString(string: NSLocalizedString("List", comment: "List"))])
        toggle.labelTappedAction = { [unowned self] (index) in
            self.toggleViews(index)
        }
        containerStackview.addArrangedSubview(toggle)
        NSLayoutConstraint.useAndActivateConstraints([
            toggle.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func toggleViews(_ index: Int) {
        let contentOffsetY = self.scrollView.contentOffset.y
        if index == 0 {
            self.scrollView.contentOffset = CGPoint(x: 0, y: contentOffsetY)
        } else {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.width, y: contentOffsetY)
        }
    }
    
    private func createScrollView() {
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
    
    private func createMapViewController() {
        let mapVM = MapPlacesViewModel()
        mapViewController = MapPlacesViewController(viewModel: mapVM)
        mapView = mapViewController.mapView
        addChildViewController(mapViewController)
        mapViewController.didMove(toParentViewController: self)
        view.addSubview(mapView)

        mapView.isHidden = true
        containerStackview.addArrangedSubview(mapView)
        NSLayoutConstraint.useAndActivateConstraints([
            mapView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3)
        ])
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

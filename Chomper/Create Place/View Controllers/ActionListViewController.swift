//
//  ActionListTableViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/25/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class ActionListViewController: BaseViewController {
    private var tableView: UITableView!
    private var viewModel: ActionListViewModel!
    
    required init(viewModel: ActionListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //
        // Create blur background view
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: .ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = UIColor.lightGrayColor()
        }
        
        //
        // Create tableView
        
        tableView = UITableView()
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        registerNibs()
        
        //
        // Create bottom cancel button
        
        let cancelButton = UIButton()
        cancelButton.tintColor = UIColor.whiteColor()
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancel"), forState: .Normal)
        cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        cancelButton.addTarget(self, action: #selector(buttonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(cancelButton)
        cancelButton.setShadow(UIColor.lightGrayColor().CGColor, opacity: 0.75, height: 3.5, shadowRect: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 1.5))
        
        NSLayoutConstraint.useAndActivateConstraints([
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: view.bounds.height * 0.5),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            cancelButton.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            cancelButton.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            cancelButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            cancelButton.heightAnchor.constraintEqualToConstant(55.0)
        ])
    }
    
    // MARK: - Handlers
    
    func registerNibs() {
        tableView.registerClass(ActionTableCell.self, forCellReuseIdentifier: "ActionCell")
        tableView.registerNib(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
    }
}

extension ActionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as? PlaceTableViewCell else { fatalError("Cannot dequeue place cell") }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell") as? ActionTableCell else { fatalError("Cannot dequeue action cell") }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            var action = viewModel.getActionForIndexPath(indexPath)
            switch action {
            case .QuickSave(_):
                action = .QuickSave(action: viewModel.saveAction)
                dismissViewControllerAnimated(true, completion: nil)
            case .AddToList(_):
                action = .AddToList(action: presentAddToListViewController())
            }
            viewModel.performAction(forAction: action)
        }
       
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            guard let cell = cell as? PlaceTableViewCell else { fatalError("wrong type: action cell") }
            cell.configureCell(withObject: viewModel.place, imageCache: imageCache)
        } else {
            guard let cell = cell as? ActionTableCell else { fatalError("wrong type: action cell") }
            let action = viewModel.getActionForIndexPath(indexPath)
            cell.setTitleForAction(viewModel.getTitleForAction(action))
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 82.0
        }
        return 60.0
    }
    
    // MARK: - Handlers
    
    func buttonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentAddToListViewController() -> (() -> Void) {
        let nav = presentingViewController
        let nc = BaseNavigationController(rootViewController: AddToListViewController(place: viewModel.place))
        nc.modalTransitionStyle = .CoverVertical
        nc.modalPresentationStyle = .OverCurrentContext
        return {
                self.dismissViewControllerAnimated(true) {
                    nav?.presentViewController(nc, animated: true, completion: nil)
                }
        }
    }
    
}






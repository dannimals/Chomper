//
//  ActionListTableViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/25/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

enum ActionValues {
    case QuickSave
    case AddToList
    
    static let allValues = [QuickSave, AddToList]
}

class ActionListViewController: BaseViewController {
    private var tableView: UITableView!
    private var place: SearchResult!
    
    required init(place: SearchResult) {
        super.init(nibName: nil, bundle: nil)
        self.place = place
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        return ActionValues.allValues.count + 1
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            guard let cell = cell as? PlaceTableViewCell else { fatalError("wrong type: action cell") }
            cell.configureCell(withObject: place)
        } else {
            guard let cell = cell as? ActionTableCell else { fatalError("wrong type: action cell") }
            let actionValue = ActionValues.allValues[indexPath.row - 1]
            switch actionValue {
            case .QuickSave:
                cell.setTitleForAction(NSLocalizedString("Save", comment: "save")) { [unowned self] in
                    self.mainContext.performChanges {
                        Place.insertIntoContext(self.mainContext, city: nil, category: nil, location: self.place.location, name: self.place.name, neighborhood: nil, notes: nil, price: self.place.price, rating: self.place.rating, remoteId: self.place.venueId, streetName: self.place.address, state: nil, visited: false, zipcode: nil, listNames: [defaultSavedList])
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            case .AddToList:
                let nav = presentingViewController
                cell.setTitleForAction(NSLocalizedString("Add to List", comment: "add to list")) { [unowned self] in
                    let nc = BaseNavigationController(rootViewController: AddToListViewController(place: self.place))
                    nc.modalTransitionStyle = .CoverVertical
                    nc.modalPresentationStyle = .OverCurrentContext
                    self.dismissViewControllerAnimated(true) {
                        nav?.presentViewController(nc, animated: true, completion: nil)
                    }
                }
            }
            
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
    
}






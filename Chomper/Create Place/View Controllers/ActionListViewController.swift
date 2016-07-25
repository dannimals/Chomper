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
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        let footer = ActionListFooterView()
        footer.buttonAction = { [unowned self] in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        tableView.addSubview(footer)
        tableView.tableFooterView = footer
        registerNibs()
        
        NSLayoutConstraint.useAndActivateConstraints([
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            (tableView.tableFooterView?.heightAnchor.constraintEqualToConstant(50.0))!
        ])
        
    }
    
    // MARK: - Handlers
    
    func registerNibs() {
        tableView.registerClass(ActionTableCell.self, forCellReuseIdentifier: "ActionCell")
        tableView.registerClass(ActionListFooterView.self, forHeaderFooterViewReuseIdentifier: "FooterView")
    }
}

extension ActionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActionValues.allValues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell") as? ActionTableCell else { fatalError("Cannot dequeue action cell") }
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? ActionTableCell else { fatalError("wrong type: action cell") }
        let actionValue = ActionValues.allValues[indexPath.row]
        switch actionValue {
            case .QuickSave:
                cell.setTitleForAction(NSLocalizedString("Save", comment: "save")) {
                    //do something
                }
            case .AddToList:
                cell.setTitleForAction(NSLocalizedString("Add to List", comment: "add to list")) {
                    // do something
                }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
}

class ActionTableCell: UITableViewCell {
    private var button: UIButton!
    private var buttonAction: (() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.titleLabel?.text = nil
        buttonAction = nil
    }
    
    private func setup() {
        button = UIButton()
        addSubview(button)
        button.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        button.addTarget(self, action: #selector(buttonTapped), forControlEvents: .TouchUpInside)

        NSLayoutConstraint.useAndActivateConstraints([
            button.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            button.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            button.topAnchor.constraintEqualToAnchor(topAnchor),
            button.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
        ])
    }
    
    func setTitleForAction(title: String, action: () -> Void) {
        button.setTitle(title, forState: .Normal)
        buttonAction = action
    }
    
    func buttonTapped() {
        buttonAction?()
    }
}

class ActionListFooterView: UITableViewHeaderFooterView {
    private var cancelButton: UIButton!
    var buttonAction: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Handlers
    
    func setup() {
        cancelButton = UIButton()
        addSubview(cancelButton)
        cancelButton.tintColor = UIColor.whiteColor()
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancel"), forState: .Normal)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("p")
        cancelButton.addTarget(self, action: #selector(buttonTapped), forControlEvents: .TouchUpInside)

        NSLayoutConstraint.useAndActivateConstraints([
            cancelButton.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            cancelButton.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            cancelButton.topAnchor.constraintEqualToAnchor(topAnchor),
            cancelButton.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
        ])
    }
    
    
    func buttonTapped() {
        buttonAction?()
    }
}
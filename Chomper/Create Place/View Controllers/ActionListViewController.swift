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
    fileprivate var tableView: UITableView!
    fileprivate var viewModel: ActionListViewModel!
    
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
            view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = UIColor.lightGray
        }
        
        //
        // Create tableView
        
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ActionTableCell.self)
        tableView.registerNib(PlaceTableViewCell.self)
        view.addSubview(tableView)
        
        //
        // Create bottom cancel button
        
        let cancelButton = UIButton()
        cancelButton.tintColor = UIColor.white
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancel"), for: UIControlState())
        cancelButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        cancelButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        cancelButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        cancelButton.setShadow(UIColor.lightGray.cgColor, opacity: 0.75, height: 3.5, shadowRect: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 1.5))
        
        NSLayoutConstraint.useAndActivateConstraints([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 55.0)
        ])
    }
}

extension ActionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier) as? PlaceTableViewCell else { fatalError("Cannot dequeue place cell") }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionTableCell.reuseIdentifier) as? ActionTableCell else { fatalError("Cannot dequeue action cell") }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            var action = viewModel.getActionForIndexPath(indexPath)
            switch action {
            case .quickSave(_):
                action = .quickSave(action: viewModel.saveAction)
                dismiss(animated: true, completion: nil)
            case .addToList(_):
                action = .addToList(action: presentAddToListViewController())
            }
            viewModel.performAction(forAction: action)
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let cell = cell as? PlaceTableViewCell else { fatalError("wrong type: action cell") }
            cell.configureCell(withObject: viewModel.place, imageCache: imageCache)
        } else {
            guard let cell = cell as? ActionTableCell else { fatalError("wrong type: action cell") }
            let action = viewModel.getActionForIndexPath(indexPath)
            cell.setTitleForAction(viewModel.getTitleForAction(action))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 82.0
        }
        return 60.0
    }
    
    // MARK: - Handlers
    
    func buttonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func presentAddToListViewController() -> (() -> Void) {
        let nav = presentingViewController
        let nc = BaseNavigationController(rootViewController: AddToListViewController(place: viewModel.place))
        nc.modalTransitionStyle = .coverVertical
        nc.modalPresentationStyle = .overCurrentContext
        return {
                self.dismiss(animated: true) {
                    nav?.present(nc, animated: true, completion: nil)
                }
        }
    }
}

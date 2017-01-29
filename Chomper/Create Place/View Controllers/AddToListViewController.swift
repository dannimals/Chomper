//
//  AddToListViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/27/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class AddToListViewController: BaseViewController {
    fileprivate var tableView: UITableView!
    fileprivate var viewModel: AddToListViewModel
    
    required init(viewModel: AddToListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Add to List", comment: "add to list")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        // TODO: Add a plus to right bar item and create option to create a new list
        
        //
        // Create tableView
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.registerCell(AddToListCell.self)
        
        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "tableView": tableView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[topLayoutGuide][tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
    }

    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddToListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddToListCell.reuseIdentifier) as? AddToListCell else { fatalError("Could not dequeue AddToListCell") }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AddToListCell else { fatalError("AddToListCell not found") }
        cell.configureCell(viewModel.getListName(atIndexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.saveToList(atIndexPath: indexPath)
        dismiss(animated: true, completion: nil)
    }
}

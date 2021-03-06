//
//  Created by Danning Ge on 7/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import Models

class ListDetailsViewController: BaseViewController {
    /*{
        didSet {
            observer = ManagedObjectObserver(object: list) { [unowned self] type in
                guard type == .Delete else { return }
                self.mainContext.performChanges {
                    self.mainContext.deleteObject(self.list)
                }
                self.dismissVC()
            }
        }
    }*/
//    fileprivate var observer: ManagedObjectObserver?
    fileprivate var tableView =  UITableView()
    fileprivate var viewModel: ListDetailsViewModel
    
    required init(viewModel: ListDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 
        // Configure view
        
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "close"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .plain, target: self, action: #selector(handleEdit))
    
        //
        // Configure table view
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(PlaceTableViewCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        let views: [String: AnyObject] = [
            "topLayout": topLayoutGuide,
            "tableView": tableView
        ]
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[topLayout][tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
    }

    // MARK - Helpers
    
    func handleEdit() {
        guard viewModel.canDeleteList else { beginEditing(); return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: NSLocalizedString("Edit list", comment: "edit"), style: .default) { [unowned self] action in
            if action.isEnabled {
                self.tableView.setEditing(true, animated: true)
                // TODO: enabled editing
            }
        }
        alertController.addAction(editAction)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete List", comment: "delete"), style: .destructive) { [unowned self] (action) in
            if action.isEnabled {
                self.alertWithCancelButton(
                    NSLocalizedString("Cancel", comment: "cancel"),
                    confirmButton: NSLocalizedString("Confirm", comment: "confirm"),
                    title: NSLocalizedString("Are you sure?", comment: "check"),
                    message: NSLocalizedString("Deleting list will also delete its associated places.", comment: "message"),
                    destructiveStyle: true, confirmBold: true, style: .alert) { bool in
                        if bool {
                            self.viewModel.deleteList()
                            self.dismissVC()
                        }
                }
            }
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }


    // MARK: - Handlers

    func deleteItemAtIndexPath(_ indexPath: IndexPath) {
        if let error = viewModel.deleteItemAtIndexPath(indexPath: indexPath) {
            alertWithButton("Ok", title: nil, message: error.description, style: .alert, dismissBlock: nil)
        } else {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func markItemAtIndexPath(_ indexPath: IndexPath) {
        if let error = viewModel.markVisitedAtIndexPath(indexPath: indexPath) {
            alertWithButton("Ok", title: nil, message: error.description, style: .alert, dismissBlock: nil)
        } else {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func beginEditing() {
        tableView.setEditing(true, animated: true)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditing))
        navigationItem.setRightBarButton(cancel, animated: true)
    }
    
    func cancelEditing() {
        tableView.setEditing(false, animated: true)
        let edit = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .plain, target: self, action: #selector(handleEdit))
        navigationItem.setRightBarButton(edit, animated: true)
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension ListDetailsViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: - UITableViewDelegate delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier) as? PlaceTableViewCell else { fatalError("cell not dequeued") }
        return cell
    }
    
    // MARK: - UITableViewDataSource delegate methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PlaceTableViewCell, let listPlace = viewModel.listPlaces?[indexPath.row]  else { fatalError("cell not found") }
        var location: CLLocation? = nil
        if let lat = listPlace.place?.latitude, let long = listPlace.place?.longitude {
            location = CLLocation(latitude: Double(lat), longitude: Double(long))
        }
        cell.configurePlaceCell(listPlace.place!.name, address: listPlace.place?.streetName, rating: listPlace.rating, price: listPlace.price, location: location, visited: listPlace.place?.visited ?? 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let listPlace = viewModel.listPlaces?[indexPath.row] else { return }
        
        let vm = PlaceDetailsViewModel(place: listPlace, webService: webService)
        let vc = PlaceDetailsViewController(viewModel: vm)
        let nc = BaseNavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItemAtIndexPath(indexPath)
        } else {
            markItemAtIndexPath(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "delete")) { [unowned self] (_, indexPath) in
            self.deleteItemAtIndexPath(indexPath)
        }
        delete.backgroundColor = UIColor.red

        let visited = UITableViewRowAction(style: .normal, title: viewModel.getEditActionTitle(atIndexPath: indexPath)) { [unowned self] (_, indexPath) in
            self.markItemAtIndexPath(indexPath)
        }
        visited.backgroundColor = UIColor.orange
        
        return [visited, delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
}

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
    private var tableView: UITableView!
    private var lists: [PlaceList]!
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
        
        navigationItem.title = NSLocalizedString("Add to List", comment: "add to list")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(dismissVC))
        // TODO: Add a plus to right bar item and create option to create a new list
        
        //
        // Create tableView
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        registerNibs()
        
        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "tableView": tableView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[topLayoutGuide][tableView]|",
            options: [],
            metrics: nil,
            views: views)
        )
        
        //
        // Create data model
        
        let request = NSFetchRequest(entityName: PlaceList.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            lists = try mainContext.executeFetchRequest(request) as! [PlaceList]
        } catch {
            fatalError("Could not load lists: \(error)")
        }
        
    }

    
    // MARK: - Handlers
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func registerNibs() {
        tableView.registerClass(AddToListCell.self, forCellReuseIdentifier: "AddToListCell")
    }
    
}

extension AddToListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("AddToListCell") as? AddToListCell else { fatalError("Could not dequeue AddToListCell") }
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? AddToListCell else { fatalError("AddToListCell not found") }
        cell.configureCell(lists[indexPath.row].name)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let list = lists[indexPath.row]
        mainContext.performChanges {
            Place.insertIntoContext(self.mainContext, city: nil, creatorId: nil, location: self.place.location, name: self.place.name, notes: nil, price: self.place.price, rating: self.place.rating, streetName: self.place.address, state: nil, updatedAt: NSDate(), visited: false, zipcode: nil, placeListName: list.name)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}


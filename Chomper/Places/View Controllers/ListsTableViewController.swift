//
//  ListsTableViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreLocation
import Models 

class ListsTableViewController: UITableViewController, BaseViewControllerProtocol, TableViewDelegate {
    typealias Data = FetchedResultsTableDataProvider<ListsTableViewController>
    private var dataProvider: Data!
    private var dataSource: TableViewDataSource<Data, ListsTableViewController, PlaceTableViewCell>!
    
    typealias Object = Place
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up dataSource
        
        setupDataSource()
        
        //
        // Set up tableView

        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.bounds.height, 0)
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
        tableView.registerClass(ListsTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    func cellIdentifierForObject(object: Object) -> String {
        return "PlaceCell"
    }
    
    func setupDataSource() {
        let fetchRequest = NSFetchRequest(entityName: Place.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)

        dataProvider = FetchedResultsTableDataProvider(tableViewDelegate: self, frc: frc)
        dataSource = TableViewDataSource(dataProvider: dataProvider, tableDelegate: self)
    }

}

extension ListsTableViewController {
    
    // MARK: - TableView delegate methods
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PlaceTableViewCell else { fatalError("Cannot dequeue PlaceCell in ListsTableVC") }
        if let object = dataProvider.objectAtIndexPath(indexPath) {
            var location: CLLocation? = nil
            if let lat = object.latitude, long = object.longitude {
                location = CLLocation(latitude: Double(lat), longitude: Double(long))
            }
            cell.configurePlaceCell(object.name, address: object.streetName, rating: object.rating, price: object.price, location: location)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82.0
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? ListsTableSectionHeaderView else { fatalError("wrong headerView in ListsTableVC") }
        view.configureHeader(NSLocalizedString("Places", comment: "Places"), count: dataProvider.numberOfItemsInSection(section))
        view.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("HeaderView") as? ListsTableSectionHeaderView else { fatalError("cannot dequeue headerView in ListsTableVC") }
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    
}
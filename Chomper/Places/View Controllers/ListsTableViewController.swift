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
    
    typealias Object = PlaceDetailsObjectProtocol
    
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
        tableView.registerNib(PlaceTableViewCell)
        tableView.registerHeaderFooter(ListsTableSectionHeaderView)
    }
    
    func cellIdentifierForObject(object: Object) -> String {
        return PlaceTableViewCell.reuseIdentifier
    }
    
    func setupDataSource() {
        let fetchRequest = NSFetchRequest(entityName: ListPlace.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "listName", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: "listName", cacheName: nil)

        dataProvider = FetchedResultsTableDataProvider(tableViewDelegate: self, frc: frc)
        dataSource = TableViewDataSource(dataProvider: dataProvider, tableDelegate: self)
    }

}

extension ListsTableViewController {
    
    // MARK: - TableView delegate methods
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PlaceTableViewCell else { fatalError("Cannot dequeue PlaceCell in ListsTableVC") }
        if let object = dataProvider.objectAtIndexPath(indexPath) {
            cell.configurePlaceCell(object.name ?? "", address: object.address, rating: object.ratingValue, price: object.priceValue, location: object.location)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let object = dataProvider.objectAtIndexPath(indexPath) {
            let vm = PlaceDetailsViewModel(place: object, webService: webService)
            let vc = PlaceDetailsViewController(viewModel: vm)
            let nc = BaseNavigationController(rootViewController: vc)
            presentViewController(nc, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82.0
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? ListsTableSectionHeaderView else { fatalError("wrong headerView in ListsTableVC") }
        let sectionName = dataProvider.nameOfSection(section) ?? ""
        view.configureHeader(sectionName, count: dataProvider.numberOfItemsInSection(section))
        view.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(ListsTableSectionHeaderView.reuseIdentifier) as? ListsTableSectionHeaderView else { fatalError("cannot dequeue headerView in ListsTableVC") }
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}

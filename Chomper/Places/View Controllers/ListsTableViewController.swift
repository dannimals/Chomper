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
    fileprivate var dataProvider: Data!
    fileprivate var dataSource: TableViewDataSource<Data, ListsTableViewController, PlaceTableViewCell>!
    
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
        tableView.separatorStyle = .none
        tableView.registerNib(PlaceTableViewCell.self)
        tableView.registerHeaderFooter(ListsTableSectionHeaderView.self)
    }
    
    func cellIdentifierForObject(_ object: Object) -> String {
        return PlaceTableViewCell.reuseIdentifier
    }
    
    func setupDataSource() {
        let fetchRequest = NSFetchRequest<ListPlace>(entityName: ListPlace.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "listName", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: "listName", cacheName: nil)

        dataProvider = FetchedResultsTableDataProvider(tableViewDelegate: self, frc: frc as! NSFetchedResultsController<NSFetchRequestResult>)
        dataSource = TableViewDataSource(dataProvider: dataProvider, tableDelegate: self)
    }
}

extension ListsTableViewController {
    
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PlaceTableViewCell else { fatalError("Cannot dequeue PlaceCell in ListsTableVC") }
        if let object = dataProvider.objectAtIndexPath(indexPath) {
            cell.configurePlaceCell(object.name , address: object.address, rating: object.ratingValue as NSNumber?, price: object.priceValue as NSNumber?, location: object.location)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let object = dataProvider.objectAtIndexPath(indexPath) {
            let vm = PlaceDetailsViewModel(place: object, webService: webService)
            let vc = PlaceDetailsViewController(viewModel: vm)
            let nc = BaseNavigationController(rootViewController: vc)
            present(nc, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? ListsTableSectionHeaderView else { fatalError("wrong headerView in ListsTableVC") }
        let sectionName = dataProvider.nameOfSection(section) ?? ""
        view.configureHeader(sectionName, count: dataProvider.numberOfItemsInSection(section))
        view.backgroundView?.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListsTableSectionHeaderView.reuseIdentifier) as? ListsTableSectionHeaderView else { fatalError("cannot dequeue headerView in ListsTableVC") }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}

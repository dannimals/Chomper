//
//  TableViewDataSource.swift
//  Chomper
//
//  Created by Danning Ge on 8/10/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class TableViewDataSource<Data: TableDataProvider, Delegate: TableViewDelegate, Cell: UITableViewCell where Data.Object == Delegate.Object>: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var dataProvider: Data!
    weak var delegate: Delegate!
    
    required init(dataProvider: Data, tableDelegate: Delegate) {
        self.dataProvider = dataProvider
        self.delegate = tableDelegate
        super.init()
        self.delegate.tableView.dataSource = self
        // TODO: Is this the best place to reload tableView immediately?
        self.delegate.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let object = dataProvider.objectAtIndexPath(indexPath) else { fatalError("Expected object at indexPath") }
        if let cell = tableView.dequeueReusableCellWithIdentifier(delegate.cellIdentifierForObject(object)) {
            delegate.configureCell(cell, forObject: object, atIndexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
}

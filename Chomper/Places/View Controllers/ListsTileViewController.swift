//
//  MyPlacesTileViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class ListsTileViewController: UICollectionViewController, BaseViewControllerProtocol, CollectionViewDelegate {
    typealias Object = PlaceList
    
    private var dataSource: ListsTileViewModel<ListsTileViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Create data source
        
        let fetchRequest = NSFetchRequest(entityName: "PlaceList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sequenceNum", ascending: false), NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = ListsTileViewModel(delegate: self, fetchedResultsController: frc)
   
        
        //
        // Set up collection view
        
        collectionView!.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.bounds.height, 0)
        collectionView!.showsVerticalScrollIndicator = false
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.registerClass(ListsCollectionViewCell.self, forCellWithReuseIdentifier: "PlaceListCell")

    }
    
    // MARK: - UICollectionViewDataSource methods
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlaceListCell", forIndexPath: indexPath) as? ListsCollectionViewCell else { fatalError("PlaceListCell not found") }
        if dataSource.objectAtIndexPath(indexPath) == nil {
            cell.addAction = { [weak self] in
                let vc = CreateListViewController()
                vc.modalTransitionStyle = .CrossDissolve
                vc.modalPresentationCapturesStatusBarAppearance = true
                self?.presentViewController(vc, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? ListsCollectionViewCell else { fatalError("PlaceListCell not found") }
        if let object = dataSource.objectAtIndexPath(indexPath) {
            cell.configureCell(object.name, count: object.places?.count ?? 0 ,hideTrailingSeparator: isEndRow(indexPath), hideBottomSeparator: isBottomRow(indexPath))
        } else {
            //
            // Object is nil means cell is a "+"
            cell.configureAddCell(isEndRow(indexPath))
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let list = dataSource.objectAtIndexPath(indexPath) {
            let vc = ListDetailsViewController(placeList: list)
            let nc = BaseNavigationController(rootViewController: vc)
            vc.title = list.name
            nc.modalTransitionStyle = .CrossDissolve
            vc.modalPresentationCapturesStatusBarAppearance = true
            presentViewController(nc, animated: true, completion: nil)
           
        }
    }
    
    // MARK: - Handlers
    
    func isEndRow(indexPath: NSIndexPath) -> Bool {
         return indexPath.row % 2 != 0
    }
    
    func isBottomRow(indexPath: NSIndexPath) -> Bool {
        let numRows = dataSource.numberOfItemsInSection(indexPath.section)
        if  numRows % 2 == 0 {
            return indexPath.row == numRows - 1 || indexPath.row == numRows - 2
        }
        return false
    }

    
}



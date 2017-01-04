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
    typealias Object = List
    
    fileprivate var dataSource: ListsTileViewModel<ListsTileViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Create data source
        
        let fetchRequest = NSFetchRequest<List>(entityName: List.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sequenceNum", ascending: false), NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = ListsTileViewModel(delegate: self, fetchedResultsController: frc as! NSFetchedResultsController<NSFetchRequestResult>)
        
        //
        // Set up collection view
        
        collectionView!.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.bounds.height, 0)
        collectionView!.showsVerticalScrollIndicator = false
        collectionView!.backgroundColor = UIColor.white
        collectionView!.registerCell(ListsCollectionViewCell.self)
    }
    
    // MARK: - UICollectionViewDataSource methods
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsCollectionViewCell.reuseIdentifier, for: indexPath) as? ListsCollectionViewCell else { fatalError("PlaceListCell not found") }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ListsCollectionViewCell else { fatalError("PlaceListCell not found") }
        if let object = dataSource.objectAtIndexPath(indexPath) {
            var image: UIImage? = UIImage() // TODO: make a placeholder image
            if let listImageId = object.listPlaces?.first?.listImageId, let imageObject = Image.findOrFetchInContext(mainContext, matchingPredicate: NSPredicate(format: "id == %@", listImageId)) {
                image = UIImage(data: imageObject.imageData)
            }
            cell.configureCell(object.name, count: object.listPlaces?.count ?? 0, image: image)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let list = dataSource.objectAtIndexPath(indexPath) {
            let vc = ListDetailsViewController(listId: list.objectID)
            let nc = BaseNavigationController(rootViewController: vc)
            vc.title = list.name
            nc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationCapturesStatusBarAppearance = true
            present(nc, animated: true, completion: nil)
        }
    }
}

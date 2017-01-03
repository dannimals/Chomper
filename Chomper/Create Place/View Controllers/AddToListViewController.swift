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
    fileprivate var lists: [List]!
    fileprivate var place: PlaceDetailsObjectProtocol!
    
    required init(place: PlaceDetailsObjectProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.place = place
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        //
        // Create data model
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: List.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            lists = try mainContext.fetch(request) as! [List]
        } catch {
            fatalError("Could not load lists: \(error)")
        }
        
    }

    // MARK: - Handlers
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddToListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddToListCell.reuseIdentifier) as? AddToListCell else { fatalError("Could not dequeue AddToListCell") }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AddToListCell else { fatalError("AddToListCell not found") }
        cell.configureCell(lists[indexPath.row].name)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let list = lists[indexPath.row]
        self.mainContext.performChanges {
            var image: Image? = nil

            let listPlace = ListPlace.insertIntoContext(self.mainContext, address: self.place.address, city: self.place.city, downloadImageUrl: self.place.imageUrl, listName: list.name, location: self.place.location, phone: self.place.phone, placeId: self.place.venueId, placeName: self.place.name, price: self.place.priceValue as NSNumber?, notes: self.place.userNotes, rating: self.place.ratingValue as NSNumber?, state: self.place.state)
            
            if let cached = (self.imageCache as? NSCache<AnyObject, AnyObject>)?.object(forKey: self.place.imageUrl as AnyObject) as? UIImage, let imageData = UIImagePNGRepresentation(cached) {
                image = Image.insertIntoContext(self.mainContext, createdAt: NSDate() as Date, imageData: imageData, thumbData: nil)
            }
            
            listPlace.listImageId = image?.id
        }

        dismiss(animated: true, completion: nil)
    }
}

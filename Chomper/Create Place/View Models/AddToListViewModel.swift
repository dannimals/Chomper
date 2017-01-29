//
//  AddToListViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 1/29/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import Models

class AddToListViewModel: BaseViewModelProtocol {
    private var imageCache: ChomperImageCacheProtocol
    private var lists: [List]
    private var mainContext: NSManagedObjectContext
    private var place: PlaceDetailsObjectProtocol
    
    required init(place: PlaceDetailsObjectProtocol,
                  mainContext: NSManagedObjectContext,
                  imageCache: ChomperImageCacheProtocol) {
        self.imageCache = imageCache
        self.mainContext = mainContext
        self.place = place
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: List.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            self.lists = try mainContext.fetch(request) as! [List]
        } catch {
            fatalError("Could not load lists: \(error)")
        }
    }
    
    func getListName(atIndexPath indexPath: IndexPath) -> String {
        return lists[indexPath.row].name
    }
    
    func getNumberOfRows() -> Int {
        return lists.count
    }
    
    func saveToList(atIndexPath indexPath: IndexPath) {
        let list = lists[indexPath.row]
        self.mainContext.performChanges {
            var image: Image? = nil
            
            let listPlace = ListPlace.insertIntoContext(self.mainContext, address: self.place.address, city: self.place.city, downloadImageUrl: self.place.imageUrl, listName: list.name, location: self.place.location, phone: self.place.phone, placeId: self.place.venueId, placeName: self.place.name, price: self.place.priceValue as NSNumber?, notes: self.place.userNotes, rating: self.place.ratingValue as NSNumber?, state: self.place.state)
            
            if let cached = (self.imageCache as? NSCache<AnyObject, AnyObject>)?.object(forKey: self.place.imageUrl as AnyObject) as? UIImage, let imageData = UIImagePNGRepresentation(cached) {
                image = Image.insertIntoContext(self.mainContext, createdAt: NSDate() as Date, imageData: imageData, thumbData: nil)
            }
            
            listPlace.listImageId = image?.id
        }
    }
}

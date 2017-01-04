//
//  MyPlacesCollectionViewLayout.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ListsCollectionViewLayout: UICollectionViewLayout {
    
    fileprivate var contentSize = CGSize.zero
    fileprivate var horizontalPadding: CGFloat = 0.0
    fileprivate var verticalPadding: CGFloat = 0.0
    fileprivate var horizontalInset: CGFloat =  2.0
    fileprivate var verticalInset: CGFloat =  2.0
    fileprivate var itemWidth: CGFloat = 0.0
    fileprivate var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    var numberOfColumns = 2
    
    override var collectionViewContentSize : CGSize {
        return contentSize
    }
    
    override func prepare() {
        super.prepare()
        
        layoutAttributes.removeAll()
        let numberOfSections = collectionView!.numberOfSections
        var yOffset = verticalInset + verticalPadding
        var xOffset = horizontalInset + horizontalPadding
        let totalGutterWidth = horizontalInset * (CGFloat(numberOfColumns + 1)) + 2 * horizontalPadding
        itemWidth = (collectionView!.bounds.width - totalGutterWidth) / CGFloat(numberOfColumns)
        
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView!.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let itemSize = CGSize(width: itemWidth, height: itemWidth)
                var increaseRow = false
                
                if collectionView!.frame.size.width - xOffset - horizontalPadding < itemWidth {
                    increaseRow = true
                }
              
                if increaseRow { //&& !(item == numberOfItems - 1 && section == numberOfSections - 1) {
                    yOffset = yOffset + verticalInset + itemSize.height
                    xOffset = horizontalInset + horizontalPadding
                }
                
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                layoutAttributes[layoutKeyforIndexPath(indexPath)] = attributes
                
                xOffset = xOffset + itemSize.width + horizontalInset
            }
        }
        
        contentSize = CGSize(width: collectionView!.frame.size.width, height: yOffset + itemWidth)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[layoutKeyforIndexPath(indexPath)]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self.layoutAttributes[evaluatedObject as! String]
            return rect.intersects(layoutAttribute!.frame)
        }
        
        let dict = layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filtered(using: predicate)
        
        return dict.objects(forKeys: matchingKeys, notFoundMarker: NSNull()) as? [UICollectionViewLayoutAttributes]
    }
    
    // MARK: - Helpers
    
    fileprivate func layoutKeyforIndexPath(_ indexPath: IndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
}

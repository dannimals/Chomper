//
//  MyPlacesCollectionViewLayout.swift
//  Chomper
//
//  Created by Danning Ge on 7/11/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class MyPlacesCollectionViewLayout: UICollectionViewLayout {
    
    private var contentSize = CGSizeZero
    private var horizontalInset: CGFloat =  0.0
    private var verticalInset: CGFloat =  0.0
    private var itemWidth: CGFloat = 0.0
    private var numberOfColumns = 3
    private var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        layoutAttributes.removeAll()
        let numberOfSections = collectionView!.numberOfSections()
        var yOffset = horizontalInset
        let totalGutterWidth = horizontalInset * (CGFloat(numberOfColumns + 1))
        itemWidth = (collectionView!.bounds.width - totalGutterWidth) / CGFloat(numberOfColumns)
        
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView!.numberOfItemsInSection(section)
            for item in 0..<numberOfItems {
                var xOffset = horizontalInset
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                let itemSize = CGSize(width: itemWidth, height: itemWidth)
                var increaseRow = false
                
                if collectionView!.frame.size.width - xOffset < itemWidth {
                    increaseRow = true
                }
                
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height))
                layoutAttributes[layoutKeyforIndexPath(indexPath)] = attributes
                
                xOffset = xOffset + itemSize.width
                xOffset = xOffset + horizontalInset
                
                if increaseRow && !(item == numberOfItems - 1 && section == numberOfSections - 1) {
                    yOffset = yOffset + verticalInset
                    yOffset = yOffset + itemSize.height
                    xOffset = horizontalInset
                }
            }
        }
        
        contentSize = CGSizeMake(collectionView!.frame.size.width, yOffset + verticalInset)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[layoutKeyforIndexPath(indexPath)]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self.layoutAttributes[evaluatedObject as! String]
            return CGRectIntersectsRect(rect, layoutAttribute!.frame)
        }
        
        let dict = layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filteredArrayUsingPredicate(predicate)
        
        return dict.objectsForKeys(matchingKeys, notFoundMarker: NSNull()) as? [UICollectionViewLayoutAttributes]
    }
    
    // MARK: - Helpers
    
    private func layoutKeyforIndexPath(indexPath: NSIndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
}

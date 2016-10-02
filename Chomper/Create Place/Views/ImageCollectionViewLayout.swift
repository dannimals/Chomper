//
//  ImageCollectionViewLayout.swift
//  Chomper
//
//  Created by Danning Ge on 10/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ImageCollectionViewLayout: UICollectionViewLayout {
    
    private var contentSize = CGSizeZero
    private var horizontalPadding: CGFloat = 3.0
    private var horizontalInset: CGFloat =  0.0
    private var verticalInset: CGFloat =  0.0
    private var itemWidth: CGFloat = 0.0
    private var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    var numberOfColumns = 0
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        layoutAttributes.removeAll()
        numberOfColumns = collectionView!.numberOfItemsInSection(0)
        var xOffset = horizontalInset
        let totalGutterWidth = horizontalInset * (CGFloat(numberOfColumns + 1)) + 2 * horizontalPadding
        itemWidth = (collectionView!.bounds.width - totalGutterWidth) / min(2.0, CGFloat(numberOfColumns))
        
        let numberOfItems = collectionView!.numberOfItemsInSection(0)
        for item in 0..<numberOfItems {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let itemSize = CGSize(width: itemWidth, height: collectionView!.bounds.height)
            
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, verticalInset, itemSize.width, itemSize.height))
            layoutAttributes[layoutKeyforIndexPath(indexPath)] = attributes
            
            xOffset = xOffset + itemSize.width + horizontalPadding
        }
        
        contentSize = CGSizeMake(xOffset + itemWidth + horizontalInset, collectionView!.bounds.height)
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

//
//  ImageCollectionViewLayout.swift
//  Chomper
//
//  Created by Danning Ge on 10/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ImageCollectionViewLayout: UICollectionViewLayout {
    
    fileprivate var contentSize = CGSize.zero
    fileprivate var horizontalPadding: CGFloat = 5.0
    fileprivate var horizontalInset: CGFloat =  0.0
    fileprivate var verticalInset: CGFloat =  5.0
    fileprivate var itemWidth: CGFloat = 0.0
    fileprivate var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    var numberOfColumns = 0
    
    override var collectionViewContentSize : CGSize {
        return contentSize
    }
    
    override func prepare() {
        super.prepare()
        
        layoutAttributes.removeAll()
        numberOfColumns = collectionView!.numberOfItems(inSection: 0)
        var xOffset = horizontalInset
        let totalGutterWidth = horizontalInset * (CGFloat(numberOfColumns + 1)) + 2 * horizontalPadding
        itemWidth = (collectionView!.bounds.width - totalGutterWidth) / min(2.0, CGFloat(numberOfColumns))
        
        let numberOfItems = collectionView!.numberOfItems(inSection: 0)
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let itemSize = CGSize(width: itemWidth, height: collectionView!.bounds.height)
            
            attributes.frame = CGRect(x: xOffset, y: verticalInset, width: itemSize.width, height: itemSize.height).integral
            layoutAttributes[layoutKeyforIndexPath(indexPath)] = attributes
            
            xOffset = xOffset + itemSize.width + horizontalPadding
        }
        
        contentSize = CGSize(width: xOffset - horizontalPadding, height: collectionView!.bounds.height)
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

//
//  MyPlacesTileViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/8/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

struct FakeData {
    var title: String!
    init(title: String) {
        self.title = title
    }
}

class MyPlacesTileViewController: UICollectionViewController, BaseViewControllerProtocol, CollectionViewDelegate {
    typealias Object = FakeData
    
    private var dataSource: MyPlacesTileViewModel<MyPlacesTileViewController>!
    private var textViewMaxY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Create data source
        
        dataSource = MyPlacesTileViewModel(delegate: self)
        
        //
        // Set up collection view
        
        collectionView!.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.bounds.height, 0)
        collectionView!.showsVerticalScrollIndicator = false
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.registerClass(MyPlacesCollectionViewCell.self, forCellWithReuseIdentifier: "PlaceListCell")
        collectionView!.keyboardDismissMode = .OnDrag

    }
    
    // MARK: - UICollectionViewDataSource methods
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section) + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlaceListCell", forIndexPath: indexPath) as? MyPlacesCollectionViewCell else { fatalError("PlaceListCell not found") }
        if indexPath.row == dataSource.numberOfItemsInSection(indexPath.section) {
            cell.configureAddCell(isEndRow(indexPath))
        } else {
            cell.configureCell("sdfsdfsdfsdfsdfsdfsdfsdfdsdfdjfssdfsdfsfsdfsfsdfsd", count: indexPath.row, hideTrailingSeparator: isEndRow(indexPath), hideBottomSeparator: isBottomRow(indexPath))
            cell.titleTextView.delegate = self
            textViewMaxY = cell.frame.height - 30.0
        }
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate methods
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    // MARK: - Handlers
    
    func isEndRow(indexPath: NSIndexPath) -> Bool {
         return indexPath.row % 2 != 0
    }
    
    func isBottomRow(indexPath: NSIndexPath) -> Bool {
        if  collectionView!.numberOfItemsInSection(indexPath.section) % 2 == 0 {
            return indexPath.row == dataSource.numberOfItemsInSection(indexPath.section) || indexPath.row == dataSource.numberOfItemsInSection(indexPath.section) - 1
        } else {
            return indexPath.row == dataSource.numberOfItemsInSection(indexPath.section) - 1
        }
    }
}

extension MyPlacesTileViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //
        // Limit text to the height of the cell - paddinng - countLabel height
        
        let currentText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        
        let attributedText = NSMutableAttributedString(string: currentText)
        attributedText.addAttribute(NSFontAttributeName, value: textView.font!, range: NSMakeRange(0, attributedText.length))
        
        let padding = textView.textContainer.lineFragmentPadding
        let boundingSize = CGSizeMake(textView.frame.size.width - padding * 2, CGFloat.max)
        let boundingRect = attributedText.boundingRectWithSize(boundingSize, options: .UsesLineFragmentOrigin, context: nil)
        
        return boundingRect.size.height + padding * 2 <= textViewMaxY ?? CGFloat.max
    }
    
    func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        // Todo: Save changes to core data
        return true
    }
    
    
    
    
    
}





















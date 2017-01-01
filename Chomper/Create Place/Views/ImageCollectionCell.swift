//
//  ImageCollectionCell.swift
//  Chomper
//
//  Created by Danning Ge on 10/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ImageCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var imageView = UIImageView()
    var photoUrl: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        photoUrl = nil
    }
    
    // MARK: - Helpers
    
    func setup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.useAndActivateConstraints([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    func configureCellWithImage(_ image: UIImage, withImageUrl url: URL, imageCache: ChomperImageCacheProtocol?) {
        if let photoUrl = photoUrl, URL(string: photoUrl) == url {
            imageView.image = image
            (imageCache as! NSCache).setObject(image, forKey: photoUrl as AnyObject)
        }
    }
}

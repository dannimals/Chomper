//
//  ImageCollectionCell.swift
//  Chomper
//
//  Created by Danning Ge on 10/2/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class ImageCollectionCell: UICollectionViewCell {
    var imageView = UIImageView()
    var photoUrl: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.useAndActivateConstraints([
            imageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor),
            imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor),
            imageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor),
            imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        photoUrl = nil
    }
}

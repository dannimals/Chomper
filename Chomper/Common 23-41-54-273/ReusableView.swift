//
//  ReusableView.swift
//  Chomper
//
//  Created by Danning Ge on 10/22/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

protocol ReusableView: class {}
protocol NibLoadableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView, NibLoadableView {}
extension UITableViewCell: ReusableView, NibLoadableView {}
extension UITableViewHeaderFooterView: ReusableView, NibLoadableView {}

extension UITableView {
    func registerNib<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.nibName)
    }
    
    func registerCell<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(_: T.Type) where T: NibLoadableView {
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.nibName)
    }
    
    func registerCell<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

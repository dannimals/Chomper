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
        return String(self)
    }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(self)
    }
}

extension UICollectionViewCell: ReusableView, NibLoadableView {}
extension UITableViewCell: ReusableView, NibLoadableView {}
extension UITableViewHeaderFooterView: ReusableView, NibLoadableView {}

extension UITableView {
    func registerNib<T: UITableViewCell where T: NibLoadableView>(_: T.Type) {
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        registerNib(Nib, forCellReuseIdentifier: T.nibName)
    }
    
    func registerCell<T: UITableViewCell where T: ReusableView>(_: T.Type) {
        registerClass(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView where T: ReusableView>(_: T.Type) {
        registerClass(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView {
    func registerNib<T: UICollectionViewCell where T: NibLoadableView>(_: T.Type) {
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        registerNib(Nib, forCellWithReuseIdentifier: T.nibName)
    }
    
    func registerCell<T: UICollectionViewCell where T: ReusableView>(_: T.Type) {
        registerClass(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

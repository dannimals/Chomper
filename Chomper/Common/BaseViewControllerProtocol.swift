//
//  BaseViewController.swift
//  Chomper
//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import WebServices


//
// BaseViewControllerProtocol to be implemented by all UIViewController classes

protocol BaseViewControllerProtocol: class {
    var webService: ChomperWebServiceProtocol { get }
    // TODO: add CoreData attributes
}

extension BaseViewControllerProtocol where Self: UIViewController {
    var webService: ChomperWebServiceProtocol { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperWebServiceProtocol.self)") as! ChomperWebServiceProtocol }

}
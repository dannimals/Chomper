//
//  BaseViewController.swift
//  Chomper
//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models
import WebServices


//
// BaseViewControllerProtocol to be implemented by all UIViewController classes
// With convenient accessors for webService, locationManager, and Core Data attributes

protocol BaseViewControllerProtocol: class {
    var webService: ChomperWebServiceProtocol { get }
    var locationManager: ChomperLocationManagerProtocol { get }
    var mainContext: NSManagedObjectContext { get }
    var imageCache: ChomperImageCacheProtocol { get }
}

extension BaseViewControllerProtocol where Self: UIViewController {
    var webService: ChomperWebServiceProtocol { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperWebServiceProtocol.self)") as! ChomperWebServiceProtocol }
    var locationManager: ChomperLocationManagerProtocol { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperLocationManagerProtocol.self)") as! ChomperLocationManagerProtocol }
    var mainContext: NSManagedObjectContext { return NSManagedObjectContext.mainContext() }
    var imageCache: ChomperImageCacheProtocol { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperImageCacheProtocol.self)") as! ChomperImageCacheProtocol }
}
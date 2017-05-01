//
//  BaseViewModel.swift
//  Chomper
//
//  Created by Danning Ge on 10/15/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models
import WebServices

class BaseViewModel {
    var webService: ChomperWebServiceProvider { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperWebServiceProvider.self)") as! ChomperWebServiceProvider }
    var locationManager: ChomperLocationManagerProtocol { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperLocationManagerProtocol.self)") as! ChomperLocationManagerProtocol }
    var mainContext: NSManagedObjectContext { return NSManagedObjectContext.mainContext() }
}

protocol BaseViewModelProtocol: class {}


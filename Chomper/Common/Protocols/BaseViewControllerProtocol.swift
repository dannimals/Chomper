//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models
import WebServices

protocol BaseViewControllerProtocol: class {
    var webService: ChomperWebServiceProvider { get }
    var locationManager: ChomperLocationManagerProtocol { get }
    var mainContext: NSManagedObjectContext { get }
    var imageCache: ChomperImageCacheProtocol { get }
}

extension BaseViewControllerProtocol where Self: UIViewController {
    var webService: ChomperWebServiceProvider { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperWebServiceProvider.self)") as! ChomperWebServiceProvider }
    var locationManager: ChomperLocationManagerProtocol { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperLocationManagerProtocol.self)") as! ChomperLocationManagerProtocol }
    var mainContext: NSManagedObjectContext { return NSManagedObjectContext.mainContext() }
    var imageCache: ChomperImageCacheProtocol { return DependencyInjector.sharedInstance.singletonForProtocol("\(ChomperImageCacheProtocol.self)") as! ChomperImageCacheProtocol }
}

//
//  Created by Danning Ge on 6/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import CoreData
import GoogleMaps
import Models
import UIKit
import WebServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let webService = ChomperProvider()

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //
        // Set up user email
        
        // TODO: Hardcode my email for now
        AppData.sharedInstance.ownerUserEmail = "danning.ge@gmail.com"

        //
        // Set up Core Data stack

        let moc = NSManagedObjectContext.mainContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: List.entityName)
        
        if (try! moc.count(for: fetchRequest) == 0){
            moc.performChanges {
                let _ = User.insertIntoContext(moc, email: AppData.sharedInstance.ownerUserEmail)
                let favorites = List.insertIntoContext(moc, name: defaultSavedList, ownerEmail: AppData.sharedInstance.ownerUserEmail)
                favorites.sequenceNum = 1
            }
        }
        
        DependencyInjector.sharedInstance.setSingleton(webService, proto: "\(ChomperWebServiceProvider.self)")
        
        let chomperImageCache = ChomperImageCache.createImageCache()
        DependencyInjector.sharedInstance.setSingleton(chomperImageCache, proto: "\(ChomperImageCacheProtocol.self)")

        GMSServices.provideAPIKey("AIzaSyAS7NhnEsmUSxBbddG80VsOljZc2uaPQMk")

        setupViewControllers()
        
        UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).tintColor = UIColor.white
        
        let attrs = [
            NSFontAttributeName: UIFont.chomperFontForTextStyle("h3"),
            NSForegroundColorAttributeName: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
       // UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).font = UIFont.chomperFontForTextStyle("p-small")
        
        let attributes = [
            NSFontAttributeName: UIFont.chomperFontForTextStyle("p-small"),
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkOrange()], for: .selected)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setupViewControllers() {
        let myPlacesVC = ListsViewController(nibName: nil, bundle: nil)
        myPlacesVC.title = NSLocalizedString("Places", comment: "Places Tab Title")
        myPlacesVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Places", comment: "Places Tab Title"),
            image: nil,
            selectedImage: nil
        )

        let viewModel = CreatePlaceViewModel(webService: webService)
        let createViewController = CreatePlaceViewController(viewModel: viewModel)
        createViewController.title = NSLocalizedString("Search", comment: "Create Places Tab Title")
        createViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Search", comment: "My Places Tab Title"),
            image: nil,
            selectedImage: nil
        )
        
        let tabViewController = UITabBarController()
        let controllers = [myPlacesVC, createViewController]
        tabViewController.viewControllers = controllers
        tabViewController.selectedViewController = myPlacesVC
        window?.rootViewController = tabViewController
        
    }
}


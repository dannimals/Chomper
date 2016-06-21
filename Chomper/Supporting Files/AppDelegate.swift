//
//  AppDelegate.swift
//  Chomper
//
//  Created by Danning Ge on 6/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import BNRCoreDataStack
import Common
import GoogleMaps
import Models
import UIKit
import WebServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var coreDataStack: CoreDataStack?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        setupTabBarVC()
        window?.makeKeyAndVisible()
        
        //
        // Set up BNRCoreDataStack
        setupCoreDataStack()
        
        //
        // Set the web service singleton for use with dependency injection
        // later
        
        let webService = ChomperWebService.createWebService()
        DependencyInjector.sharedInstance.setSingleton(webService, proto: "\(ChomperWebServiceProtocol.self)")
        
        //
        // GoogleMaps authorization
        GMSServices.provideAPIKey("AIzaSyAS7NhnEsmUSxBbddG80VsOljZc2uaPQMk")
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Helpers
    
    func setupCoreDataStack() {
        
        CoreDataStack.constructSQLiteStack(withModelName: "Model", inBundle: NSBundle(forClass: Place.self)) { result in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
            case .Failure(let error):
                fatalError("Error creating stack: \(error)")
            }
        }
    }
    
    func setupTabBarVC() {
        let myPlacesVC = MyPlacesViewController(nibName: nil, bundle: nil)
        myPlacesVC.title = NSLocalizedString("My Places", comment: "My Places Tab Title")
        myPlacesVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("My Places", comment: "My Places Tab Title"),
            image: nil,
            selectedImage: nil
        )
        let nc = UINavigationController(rootViewController: myPlacesVC)
        
        let createPlaceVC = CreatePlaceViewController(nibName: nil, bundle: nil)
        createPlaceVC.title = NSLocalizedString("Add", comment: "Add Tab Title")
        createPlaceVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Add", comment: "My Places Tab Title"),
            image: nil,
            selectedImage: nil
        )
        let nc2 = UINavigationController(rootViewController: createPlaceVC)
        
        let browsePlacesVC = MyPlacesViewController(nibName: nil, bundle: nil)
        browsePlacesVC.title = NSLocalizedString("Browse", comment: "Browse Tab Title")
        browsePlacesVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Browse", comment: "Browse Tab Title"),
            image: nil,
            selectedImage: nil
        )
        let nc3 = UINavigationController(rootViewController: browsePlacesVC)
        
        let tabBarVC = UITabBarController()
        let controllers = [nc, nc2, nc3]
        tabBarVC.viewControllers = controllers
        tabBarVC.selectedViewController = nc2
        window?.rootViewController = tabBarVC
        
    }
}


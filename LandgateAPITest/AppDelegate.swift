//
//  AppDelegate.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 5/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		// Realm database version migration code. Only runs when the database version number increments.
		Realm.Configuration.defaultConfiguration = Realm.Configuration(
			schemaVersion: 2,
			migrationBlock: { migration, oldSchemaVersion in
				if (oldSchemaVersion < 2) {
					print("Migrating database versions!")
					migration.enumerate(EndpointResult.className()) { oldObject, newObject in
						newObject!["uploaded"] = false
						newObject!["httpMethod"] = "GET"
						newObject!["server"] = "GME"
						newObject!["testName"] = ""
						
						if let data: NSData = oldObject!["responseData"] as? NSData {
							if let _: UIImage = UIImage(data: data) {
								print("Converting an NSData to a UIImage succeeded! Assigning properties as per a WMS image return.")
								newObject!["dataset"] = "AerialPhoto"
								newObject!["returnType"] = "Image"
								
							} else {
								print("Found an NSData which could not be converted to UIImage. Assuming JSON from the GME days.")
								newObject!["dataset"] = "BusStops"
								newObject!["returnType"] = "JSON"
							}
						} else {
							print("No response data found! Probably a failed test.")
							newObject!["dataset"] = ""
							newObject!["returnType"] = ""
						}
					}
				}
			}
		)
		
		// Wake up the singleton test manager state machine.
		let testManager = TestManager.sharedInstance
		testManager.stateMachine.fireEvent(ManagerEvents.Awake)
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Send events to both singleton state machine managers to abort and prepare to be torn down.
		TestManager.sharedInstance.stateMachine.fireEvent(ManagerEvents.Abort)
		TestUploader.sharedInstance.stateMachine.fireEvent(UploaderEvents.Abort)
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


}


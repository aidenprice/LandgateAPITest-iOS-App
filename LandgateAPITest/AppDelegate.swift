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
		print("Application Did Finish Launching with Options!")
		
		// Running Realm()'s writeCopyToPath compacts the database en route to save memory.
		// Also used here to save a backup copy.
		// This code will only be run one time, it raises an error if the destination file already exists.
		
//		let fileManager = NSFileManager.defaultManager()
//		
//		let bundledRealmPath = NSBundle.mainBundle().pathForResource("backup", ofType:"realm")
//		
//		let defaultRealmPath = NSURL.fileURLWithPath(Realm.Configuration.defaultConfiguration.path!)
//		guard let copyRealmPath = defaultRealmPath.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("backup.realm") else { return true }
		
//		let config = Realm.Configuration(path: bundledRealmPath, readOnly: true)
//		
//		let realm = try! Realm(configuration: config)
//		
//		do {
//			print("Starting deletion of old default realm file.")
//			try fileManager.removeItemAtURL(defaultRealmPath)
//			
//			print("Starting writeCopyToPath")
//			try realm.writeCopyToPath(defaultRealmPath.path!)
//			
//		} catch let error as NSError {
//			print("Error while copying default Realm file: \(error)")
//		}
		
//		do {
//			print("Starting writeCopyToPath")
//			try Realm().writeCopyToPath(copyRealmPath.path!)
//			
//			print("Starting deletion of old default realm file.")
//			try fileManager.removeItemAtURL(defaultRealmPath)
//
//			print("Starting copying backup realm across to default path.")
//			try fileManager.copyItemAtURL(copyRealmPath, toURL: defaultRealmPath)
//			
//		} catch let error as NSError {
//			print("Error while copying default Realm file: \(error)")
//		}
		
//		print("Backup complete.")
		
		// Realm database version migration code. Only runs when the database version number increments.
		Realm.Configuration.defaultConfiguration = Realm.Configuration(
			schemaVersion: 12,
			migrationBlock: { migration, oldSchemaVersion in
				print("Migration underway! Old schema version = \(oldSchemaVersion)")
				if (oldSchemaVersion < 2) {
					// This migration converted some old Google Maps Engine test results to the
					// newest database schema, otherwise they would have fallen through the cracks.
					
					print("Migrating database version 1 to 2!")
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
				if (oldSchemaVersion < 3) {
					// This migration nominated the "testID" property as the primary key for each record.
					
					print("Migrating database version 2 to 3!")
					migration.enumerate(ResultObject.className()) { oldObject, newObject in
						newObject!["primaryKeyProperty"] = "testID"
					}
				}
				if (oldSchemaVersion < 4) {
					// This migration diliberately sets all uploaded flags back to false before
					// a big Google App Engine database wipe and rebuild.
					// Also there was an error found where some WMS images were incorrectly tagged
					// as JSON responses, this migration tests for those with images and sets 
					// their tag correctly.
					
					print("Migrating database version 3 to 4!")
					migration.enumerate(ResultObject.className()) { oldObject, newObject in
						if let uploadedFlag = oldObject!["uploaded"] as? Bool where uploadedFlag == true {
							print("Setting uploaded flag to false")
							newObject!["uploaded"] = false
						}
						if let serverType = oldObject!["server"] as? String where serverType == "Esri" {
							print("Setting server type to all caps ESRI")
							newObject!["server"] = "ESRI"
						}
						if let data: NSData = oldObject!["responseData"] as? NSData,
								_: UIImage = UIImage(data: data),
								datasetName =  oldObject!["dataset"] as? String,
								dataType = oldObject!["returnType"] as? String
								where datasetName == "BusStops" && dataType == "JSON" {
							print("Converting an NSData to a UIImage succeeded! Assigning properties as per a WMS image return.")
							newObject!["dataset"] = "Topo"
							newObject!["returnType"] = "Image"
						}
					}
				}
				if (oldSchemaVersion < 8) {
					// The previous migration failed to change the uploaded flags, dataset and returnType values. Retrying here.
					// In case you're wondering about the Pyramid of Doom of if clauses, I tried the modern Swift version above and it wasn't called.
					print("Migrating database version 7 to 8!")
					migration.enumerate(EndpointResult.className()) { oldObject, newObject in
						print("Old object uploaded flag: \(oldObject!["uploaded"])")
						newObject!["uploaded"] = false
						print("New object uploaded flag: \(newObject!["uploaded"])")
						
						if let serverType = oldObject!["server"] as? String {
							if serverType == "Esri" {
								print("Setting server type to all caps ESRI")
								newObject!["server"] = "ESRI"

							}
						}
						
						if let data: NSData = oldObject!["responseData"] as? NSData {
							if let _: UIImage = UIImage(data: data) {
								let datasetName =  oldObject!["dataset"] as? String
								let dataType = oldObject!["returnType"] as? String
								if datasetName == "BusStops" && dataType == "JSON" {
									print("Converting an NSData to a UIImage succeeded! Assigning properties as per a WMS image return.")
									newObject!["dataset"] = "Topo"
									newObject!["returnType"] = "Image"
								}
							}
						}
					}
				}
				if (oldSchemaVersion < 12) {
					// Resetting all uploadedFlags to false in preparation for dumping the test
					// database in favour of the production dataset.
					print("Migrating database version 11 to 12!")
					migration.enumerate(TestMasterResult.className()) { oldObject, newObject in
						if let uploadedFlag = oldObject!["uploaded"] as? Bool {
							print("Uploaded flag before = \(uploadedFlag)")
							newObject!["uploaded"] = false
							print("Uploaded flag after = \(uploadedFlag)")
						}
					}
					migration.enumerate(EndpointResult.className()) { oldObject, newObject in
						if let uploadedFlag = oldObject!["uploaded"] as? Bool {
							print("Uploaded flag before = \(uploadedFlag)")
							newObject!["uploaded"] = false
							print("Uploaded flag after = \(uploadedFlag)")
						}
					}
					migration.enumerate(NetworkResult.className()) { oldObject, newObject in
						if let uploadedFlag = oldObject!["uploaded"] as? Bool {
							print("Uploaded flag before = \(uploadedFlag)")
							newObject!["uploaded"] = false
							print("Uploaded flag after = \(uploadedFlag)")
						}
					}
					migration.enumerate(LocationResult.className()) { oldObject, newObject in
						if let uploadedFlag = oldObject!["uploaded"] as? Bool {
							print("Uploaded flag before = \(uploadedFlag)")
							newObject!["uploaded"] = false
							print("Uploaded flag after = \(uploadedFlag)")
						}
					}
					migration.enumerate(PingResult.className()) { oldObject, newObject in
						if let uploadedFlag = oldObject!["uploaded"] as? Bool {
							print("Uploaded flag before = \(uploadedFlag)")
							newObject!["uploaded"] = false
							print("Uploaded flag after = \(uploadedFlag)")
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


//
//  HomeTableViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 25/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

import RealmSwift

extension Array {
	func randomElement() -> Element {
		let index = Int(arc4random()) % Int(count)
		return self[index]
	}
}

struct HomeConstants {
	static let tipsSegueID = "TipsSegue"
	static let creditsSegueID = "CreditsSegue"
	static let newTestSegueID = "newTestSegue"
	static let oldTestSegueID = "oldTestSegue"
	
	static let homeCellReuse = "HomeTableViewCell"
	
	static let tipsTitle = "Tips"
	static let creditsTitle = "Credits"
	static let newTestTitle = "New Test"
	static let newTestDetail = "Ready to test?"
	static let oldTestTitle = "Old Tests"
	static let errorCaseTitle = "Error!"
	static let errorCaseDetail = "Something is the matter, there should be helpful text here and not an error message!"
}

//class HomeTableViewCell: UITableViewCell {
//	
//}

class HomeTableViewController: UITableViewController {
	var testsComplete = 0
	var testsYetToUpload = 0
	
	lazy var realm: Realm = {
		print("Realm started! Check for multiple startups!")
		var testRealm: Realm
		do {
			try testRealm = Realm()
			print("Using default Realm")
			
		} catch {
			
			var realmFailAlert = UIAlertController(title: "Data storage error!", message: "The app is unable to save your test data to disk. We'll save data in memory to allow you to upload it but it will not persist between app launches. Thank you!", preferredStyle: UIAlertControllerStyle.Alert)
			
			realmFailAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
				print("OK Selected, lets get on with it.")
				
			}))
			self.presentViewController(realmFailAlert, animated: true, completion: nil)

			try! testRealm = Realm(configuration: Realm.Configuration(inMemoryIdentifier: "InMemoryRealm"))
			print("Using In Memory Realm")
		}
		print(testRealm)
		return testRealm
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.estimatedRowHeight = 70.0
		tableView.rowHeight = UITableViewAutomaticDimension
		
		testsComplete = realm.objects(TestMasterResult).count
		testsYetToUpload = realm.objects(TestMasterResult).filter("uploaded == false").count
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0: return 1
			case 1: return 2
			case 2: return 1
			default: return 1
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeConstants.homeCellReuse, forIndexPath: indexPath)

		switch indexPath.section {
			case 0:
				cell.textLabel?.text = HomeConstants.tipsTitle
				cell.detailTextLabel?.text = Tips.tipList.randomElement()
			case 1 where indexPath.row == 0:
				cell.textLabel?.text = HomeConstants.newTestTitle
				cell.detailTextLabel?.text = HomeConstants.newTestDetail
			case 1 where indexPath.row == 1:
				cell.textLabel?.text = HomeConstants.oldTestTitle
				cell.detailTextLabel?.text = "Completed tests: \(self.testsComplete)\nTests yet to upload: \(self.testsYetToUpload)\nYou can upload later over WiFi to save data."
			case 2:
				cell.textLabel?.text = HomeConstants.creditsTitle
				cell.detailTextLabel?.text = "Thank you to \(Credits.helpers.randomElement())"
			default:
				cell.textLabel?.text = HomeConstants.errorCaseTitle
				cell.detailTextLabel?.text = HomeConstants.errorCaseDetail
		}

        return cell
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		
		switch indexPath.section {
			case 0:
				self.performSegueWithIdentifier(HomeConstants.tipsSegueID, sender: cell)
			case 1 where indexPath.row == 0:
				self.performSegueWithIdentifier(HomeConstants.newTestSegueID, sender: cell)
			case 1 where indexPath.row == 1:
				self.performSegueWithIdentifier(HomeConstants.oldTestSegueID, sender: cell)
			case 2:
				self.performSegueWithIdentifier(HomeConstants.creditsSegueID, sender: cell)
			default:
				break
		}
	}
}

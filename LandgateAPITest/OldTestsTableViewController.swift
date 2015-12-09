//
//  OldTestsTableViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 28/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

//import Realm
import RealmSwift

struct OldTestConstants {
	static let oldTestCellReuse = "OldTestsTableViewCell"
}

class OldTestTableViewCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var detailLabel: UILabel!
	
}

class OldTestsTableViewController: UITableViewController {

	var completedTests: Results<TestMasterResult>?
	
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
	
	func uploadAll() {
		print("Upload All button pressed!")
		guard let allTests = self.completedTests where allTests.count > 0 else { return }
		print("There are tests not yet uploaded!")
		let tests = allTests.filter("uploaded == false")
		
		for test in tests {
			
			print(test)
		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload All", style: .Plain, target: self, action: "uploadAll")
		
		completedTests = realm.objects(TestMasterResult)
		
		tableView.estimatedRowHeight = 70.0
		tableView.rowHeight = UITableViewAutomaticDimension
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard let tests = completedTests else {
			return 0
		}
		
        return tests.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(OldTestConstants.oldTestCellReuse, forIndexPath: indexPath) as! OldTestTableViewCell
		
		guard let test = completedTests?[indexPath.row] else {
			cell.titleLabel.text = "No tests found"
			cell.detailLabel.text = ""
			return cell
		}
		
		cell.titleLabel.text = "\(NSDate(timeIntervalSince1970: test.datetime))"
		cell.detailLabel.text = "Uploaded: \(test.uploaded) Successful: \(test.success)"
		
        return cell
    }
}

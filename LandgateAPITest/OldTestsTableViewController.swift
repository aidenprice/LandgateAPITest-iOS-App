//
//  OldTestsTableViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 28/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		completedTests = realm.objects(TestMasterResult)
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return (completedTests?.count)!
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

        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

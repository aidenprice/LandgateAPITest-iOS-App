//
//  FirstTableViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 25/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

import RealmSwift

extension Array {
	func randomElement() -> Element {
		let index = Int(arc4random_uniform(UInt32(self.count)))
		return self[index]
	}
}

struct StringConstants {
	static let tipsSegueID = "TipsSegue"
	static let creditsSegueID = "CreditsSegue"
	static let firstCellReuse = "FirstTableViewCell"
	static let tipsTitle = "Tips"
	static let creditsTitle = "Credits"
	static let newTestTitle = "New Test"
	static let newTestDetail = "Ready to test?"
	static let oldTestTitle = "Old Test"
	static let errorCaseTitle = "Error!"
	static let errorCaseDetail = "Something is the matter, there should be helpful text here and not an error message!"
}

class FirstCell: UITableViewCell {
	
	@IBOutlet weak var titleText: UILabel!
	
	@IBOutlet weak var detailText: UILabel!
	
}

class FirstTableViewController: UITableViewController {
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
		testsComplete = realm.objects(TestMasterResult).count
		testsYetToUpload = realm.objects(TestMasterResult).filter("uploaded == 'NO'").count
		
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
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.firstCellReuse, forIndexPath: indexPath) as! FirstCell

		switch indexPath.section {
			case 0:
				cell.titleText.text = StringConstants.tipsTitle
				cell.detailText.text = Tips.tipList.randomElement()
			case 1 where indexPath.row == 0:
				cell.titleText.text = StringConstants.newTestTitle
				cell.detailText.text = StringConstants.newTestDetail
			case 1 where indexPath.row == 1:
				cell.titleText.text = StringConstants.oldTestTitle
				cell.detailText.text = "Completed tests: \(self.testsComplete)\nTests yet to upload: \(self.testsYetToUpload)\nYou can upload later over WiFi to save data."
			case 2:
				cell.titleText.text = StringConstants.creditsTitle
				cell.detailText.text = "Thank you to \(Credits.helpers.randomElement())"
			default:
				cell.titleText.text = StringConstants.errorCaseTitle
				cell.detailText.text = StringConstants.errorCaseDetail
		}

        return cell
    }

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		
		switch indexPath {
			case 0:
				self.performSegueWithIdentifier(StringConstants.tipsSegueID, sender: cell)
			case 3:
				self.performSegueWithIdentifier(StringConstants.creditsSegueID, sender: cell)
			default:
				break
		}
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
}

//
//  NewTestTableViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 28/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

struct NewTestConstants {
	static let newTestCellReuse = "NewTestTableViewCell"
	
	static let testDetailsSegueID = "testDetailsSegue"
}

class NewTestTableViewCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var detailLabel: UILabel!
	
	@IBOutlet weak var testImage: UIImageView!
	
	var template: TMTemplate?
	
}

class NewTestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
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
        return TestMaster.Templates.count
    }
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewTestConstants.newTestCellReuse, forIndexPath: indexPath) as! NewTestTableViewCell

		print(cell)
		
		cell.template = TestMaster.Templates[indexPath.row]
		
		cell.titleLabel.text = TestMaster.Templates[indexPath.row].name
		cell.detailLabel.text = TestMaster.Templates[indexPath.row].details
		cell.testImage.image = TestMaster.Templates[indexPath.row].image

        return cell
    }


	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		guard let destination = segue.destinationViewController as? TestViewController else {
			return
		}
		
		guard let cell = sender as? NewTestTableViewCell else {
			return
		}
		
		destination.template = cell.template
		
    }
}

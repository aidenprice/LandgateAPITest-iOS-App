//
//  TestViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 30/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

import RealmSwift

class TestViewController: UIViewController, TestManagerDelegate {
	
	var template: TMTemplate?
	
	var testManager: TestManager?

	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var downloadLabel: UILabel!
	
	@IBAction func startButtonPressed(sender: UIButton) {
		
		testManager = TestManager.sharedInstance
		
		
	}
	
	func didStartTesting() {
		
	}
	
	func didFinishTesting(realm: Realm, testID: String) {
		
	}
	
	func didFailToStartTest(reason: String) {
		
	}
	
	func didFailToInitDefaultRealm(title: String, message: String) {
		
	}
	
	func didFailWithError(reason: String) {
		
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		guard let template = self.template else {
			return
		}
		
		self.image.image = template.image
		self.titleLabel.text = template.name
		self.detailLabel.text = template.details
		self.downloadLabel.text = "Download size: \(template.downloadSize)Kb"
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

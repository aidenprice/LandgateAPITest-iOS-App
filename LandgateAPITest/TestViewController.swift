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

	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var downloadLabel: UILabel!
	
	@IBAction func startButtonPressed(sender: UIButton) {
		
		guard let testTemplate = self.template else {
			self.didFailToStartTest("No test plan to pass to Statemachine!")
			return
		}
		
		let testManager = TestManager.sharedInstance
		
		testManager.testPlan = testTemplate.testPlan//[0..<testTemplate.testPlan.count]
		
	}
	
	func didStartTesting() {
		
		// Segue-ing from the storyboard instead of here, need to fix that.
		
		//popup or modal view with progress indicator
		
	}
	
	func didFinishTesting(realm: Realm, testID: String) {
		
		//remove modal view and segue to result controller
		
	}
	
	func didFailToStartTest(reason: String) {
		
		let statemachineFailAlert = UIAlertController(title: "Statemachine error!", message: "The app is currently unable to start testing. This is most likely due to either the outright lack of an internet connection or ongoing background logic. Please move around to get signal or try again later. Thank you!", preferredStyle: UIAlertControllerStyle.Alert)
		
		statemachineFailAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
			print("OK Selected on Unable to start test.")
			
		}))
		self.presentViewController(statemachineFailAlert, animated: true, completion: { _ in TestManager.sharedInstance.stateMachine.fireEvent(ManagerEvents.Abort) })
		
	}
	
	func didFailToInitDefaultRealm(title: String, message: String) {
		
		let realmFailAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		
		realmFailAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
			print("OK Selected on realmFail delegate method alert.")
			
		}))
		self.presentViewController(realmFailAlert, animated: true, completion: { _ in TestManager.sharedInstance.stateMachine.fireEvent(ManagerEvents.Abort) })
		
	}
	
	func didFailWithError(reason: String) {
		
		let genericFailAlert = UIAlertController(title: "Something's wrong here!", message: reason, preferredStyle: UIAlertControllerStyle.Alert)
		
		genericFailAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
			print("OK Selected on genericFail delegate method alert.")
			
		}))
		self.presentViewController(genericFailAlert, animated: true, completion: { _ in TestManager.sharedInstance.stateMachine.fireEvent(ManagerEvents.Abort) })
		
	}
	
    override func viewDidLoad() {
		
        super.viewDidLoad()

		TestManager.sharedInstance.delegate = self
		
		if let template = self.template  {
		
			self.image.image = template.image
			self.titleLabel.text = template.name
			self.detailLabel.text = template.details
			self.downloadLabel.text = "Download size: \(template.downloadSize)Kb"
				
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

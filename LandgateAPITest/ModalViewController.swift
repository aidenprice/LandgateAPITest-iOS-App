//
//  ModalViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 2/12/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, TestManagerProgressDelegate {
	
	@IBOutlet weak var progressView: KDCircularProgress!

	@IBAction func cancel(sender: UIButton) {
		
		// TODO: consider forcing SingletonTestManager's progressDelegate to nil. See whether it happens on it's own in any case with didSet.
		TestManager.sharedInstance.stateMachine.fireEvent(ManagerEvents.Abort)
		
		progressView.animateFromAngle(progressView.angle, toAngle: 0, duration: 0.5, completion: nil)
		
		self.dismissViewControllerAnimated(true, completion: nil)
	
	}
	
	func progressReport(progress: Double) {
		print("Progress: \(progress)")
		
		if Int(360.0 * progress) > progressView.angle {
			progressView.animateToAngle(Int(360.0 * progress), duration: 0.5, completion: nil)
		}
	}
	
	func didFinishTesting(testID: String) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
	
	}
	
	func didFailWithError(reason: String) {
		
		let genericFailAlert = UIAlertController(title: "Something's wrong here!", message: reason, preferredStyle: UIAlertControllerStyle.Alert)
		
		genericFailAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
			print("OK Selected on genericFail delegate method alert.")
			
		}))
		self.presentViewController(genericFailAlert, animated: true, completion: { _ in TestManager.sharedInstance.stateMachine.fireEvent(ManagerEvents.Abort)
			self.progressView.animateFromAngle(self.progressView.angle, toAngle: 0, duration: 0.5, completion: nil)
			self.dismissViewControllerAnimated(true, completion: nil)
		})
		
	}
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
		
		TestManager.sharedInstance.progressDelegate = self

		progressView.angle = 0
		
    }

    override func didReceiveMemoryWarning() {
		
        super.didReceiveMemoryWarning()

    }
}

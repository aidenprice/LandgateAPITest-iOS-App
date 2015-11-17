//
//  CreditsViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 12/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.textView.text = codeCredits
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	let codeCredits = "Thanks to these people;\nDenys Telezhkin\nashleymills\nJens Schwarzer\nThe Realm Team"
	
	let supportersCredits = ""
	
	let licenceText = ""
	
}

//
//  CreditsViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 12/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

// MARK: Credits View Controller
/**
	A very simple view controller that builds a concatenated text view to thank all the people who helped make the app possible.
*/
class CreditsViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Build the credits view simply from concatenated text in the Credits model file.
		var text = "The best helpers a dev could have;\n\n"
		text += Credits.helpers.joinWithSeparator("\n\n")
		text += "\n\nCoders who made their code available through Stack Overflow;\n\n"
		text += Credits.coders.joinWithSeparator("\n\n")
		text += "\n\nLicences for open source libraries used in this app;\n\n"
		
		for (key, value) in Credits.licences {
			text += "\(key)\n\n\(value)\n\n"
		}
		
		self.textView.text = text
		
		// This line forces the textView to start at the top of its scroll range, not sure why they don't do so automatically...
		self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.textView.contentOffset.y = 0
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

//
//  TipsViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 24/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.textView.text = Tips.tipList.joinWithSeparator(", \n")
		
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

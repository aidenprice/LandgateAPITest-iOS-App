//
//  TestMasterTemplates.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 5/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import UIKit


struct TMTemplate {
	let name: String
	let details: String
	let image: UIImage
	let downloadSize: Int
	let testPlan: []
	
}


struct TestMaster {
	static let Standard = TMTemplate(
		name: "Standard Test",
		details: "The basic test format and a good all-rounder. " +
				"Tests a variety of endpoints; GeoJSON, WMS, WMTS. " +
				"Asks for small responses for the most part to minimise " +
				"data downloads. One in 10 requests is much larger as a " +
				"control on network latency on response time.",
		downloadSize: 1,
		image: UIImage(named: "Standard Icon")!
	)
	static let ExtraLong = TMTemplate(
		name: "Extra Long Test",
		details: "A repetitious test over a long period asking for small " +
				"JSON responses over and over and over. This is a good one " +
				"for those times when you're planning on moving about a lot, " +
				"say on the train or bus.",
		downloadSize: 1,
		image: UIImage(named: "Extra Long Icon")!
	)
	static let RemoteArea = TMTemplate(
		name: "Remote Area Test",
		details: "A test designed for areas with dodgy signal (some of the " +
				"best places on Earth, frankly). Has longer time out times " +
				"and calls for smaller responses.",
		downloadSize: 1,
		image: UIImage(named: "Remote Area Icon")!
	)
	static let WMS = TMTemplate(
		name: "WMS Test",
		details: "This test calls for image responses rather than XML or JSON." +
				"It is designed to look for image flaws that may happen when " +
				"your signal drops out partway through a response.\nImportantly, " +
				"this test can lead to big downloads. Please use it sparingly.",
		downloadSize: 1,
		image: UIImage(named: "WMS Icon")!
	)
	static let WiFi = TMTemplate(
		name: "WiFi Test",
		details: "Please DON'T use this test on a 3G or 4G connection, if you " +
				"value your download cap!\nThis is deliberately designed to be " +
				"a big test, looking for big and small responses to control network " +
				"latency.\nDon't test this on your stable home wifi, find some " +
				"flakey wifi network on campus instead. Or better yet, run this test " +
				"while moving between two wifi access points.",
		downloadSize: 1,
		image: UIImage(named: "WiFi Icon")!
	)
}




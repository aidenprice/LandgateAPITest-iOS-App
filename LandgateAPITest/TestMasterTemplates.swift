//
//  TestMasterTemplates.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 5/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import UIKit


struct Template {
	let name: String
	let details: String
	let downloadSize: Int
	let image: UIImage
}


struct TestMaster {
	static let Standard = Template(
		name: "Standard Test",
		details: "The basic test format and a good all-rounder. " +
		"Tests a variety of endpoints; GeoJSON, WMS, WMTS. " +
		"Asks for small responses for the most part to minimise " +
		"data downloads. One in 10 requests is much larger as a " +
		"control on network latency on response time.",
		downloadSize: 1,
		image: UIImage(named: "Standard Icon")!
	)
	static let ExtraLong = Template(
		name: "Extra Long Test",
		details: "",
		downloadSize: 1,
		image: UIImage(named: "Extra Long Icon")!
	)
	static let RemoteArea = Template(
		name: "Remote Area Test",
		details: "",
		downloadSize: 1,
		image: UIImage(named: "Remote Area Icon")!
	)
	static let WMS = Template(
		name: "WMS Test",
		details: "",
		downloadSize: 1,
		image: UIImage(named: "WMS Icon")!
	)
	static let WiFi = Template(
		name: "WiFi Test",
		details: "",
		downloadSize: 1,
		image: UIImage(named: "WiFi Icon")!
	)
}




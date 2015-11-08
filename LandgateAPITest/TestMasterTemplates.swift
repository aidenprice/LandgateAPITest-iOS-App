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
		"Standard Test",
		"The basic test format and a good all-rounder. " +
		"Tests a variety of endpoints; GeoJSON, WMS, WMTS. " +
		"Asks for small responses for the most part to minimise " +
		"data downloads. One in 10 requests is much larger as a " +
		"control on network latency on response time.",
		1,
		""
	)
	static let ExtraLong = Template(
		"Extra Long Test",
		"",
		1,
		""
	)
	static let RemoteArea = Template(
		"Remote Area Test",
		"",
		1,
		""
	)
	static let WMS = Template(
		"WMS Test",
		"",
		1,
		""
	)
	static let WiFi = Template(
		"WiFi Test",
		"",
		1,
		""
	)
}




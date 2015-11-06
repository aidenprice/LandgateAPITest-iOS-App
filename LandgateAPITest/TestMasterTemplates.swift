//
//  TestMasterTemplates.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 5/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import UIKit

enum TestMaster {
	case Standard
	case ExtraLong
	case RemoteArea
	case WMSTest
	case WiFiTest
	
	func template () -> Template {
		switch self {
			case .Standard:
				return StandardTestMaster()
			case .ExtraLong:
				return ExtraLongTestMaster()
			case .RemoteArea:
				return RemoteAreaTestMaster()
			case .WMSTest:
				return WMSTestMaster()
			case .WiFiTest:
				return WiFiTestMaster()
		}
	}
}

protocol Template {
	var name: String { get }
	var details: String { get }
	var downloadSize: Int { get }
	var image: UIImage { get }
}

private struct StandardTestMaster: Template {
	static let name: String = "Standard Test"
	static let details: String = "The basic test format and a good all-rounder. " +
						  "Tests a variety of endpoints; GeoJSON, WMS, WMTS. " +
						  "Asks for small responses for the most part to minimise " +
						  "data downloads. One in 10 requests is much larger as a " +
						  "control on network latency on response time."
	static let downloadSize: Int = 1
	static let image: UIImage = ""
	
}

private struct ExtraLongTestMaster: Template {
	static let name: String = "Extra Long Test"
	static let details: String = ""
	static let downloadSize: Int = 1
	static let image: UIImage = ""
	
}

private struct RemoteAreaTestMaster: Template {
	static let name: String = "Remote Area Test"
	static let details: String = ""
	static let downloadSize: Int = 1
	static let image: UIImage = ""
	
}

private struct WMSTestMaster: Template {
	static let name: String = "WMS Test"
	static let details: String = ""
	static let downloadSize: Int = 1
	static let image: UIImage = ""

}

private struct WiFiTestMaster: Template {
	static let name: String = "WiFi Test"
	static let details: String = ""
	static let downloadSize: Int = 1
	static let image: UIImage = ""

}






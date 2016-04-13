//
//  NetworkTester.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 17/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import CoreTelephony

protocol NetworkTesterDelegate: class {
	func didFinishNetwork(sender: NetworkTester, result: NetworkResult)
}

// Singleton NetworkTester class checks cell connection type and carrier returning a NetworkResult object to its delegate.
class NetworkTester {
	static let sharedInstance = NetworkTester()
	
	weak var delegate: NetworkTesterDelegate?
	
	var networkResult: NetworkResult?
	
	func network(delegateObject: TestManager, id: idDetails) throws {
		self.delegate = delegateObject
		self.networkResult = NetworkResult()
		
		guard let delegate = self.delegate, networkResult = self.networkResult else {
			print("Network method failed. Missing either a delegateObject or a NetworkResult")
			throw SubTestError.missingResultObject(reason: "Network method failed. Missing either a delegateObject or a NetworkResult")
		}
		
		// Standard resultObject ID properties
		networkResult.datetime = NSDate().timeIntervalSince1970
		networkResult.testID = "\(id.deviceID)/\(networkResult.datetime)"
		networkResult.parentID = id.parentID
		
		// Grab the latest version of the device's NetworkInfo object
		let connectionInfo = CTTelephonyNetworkInfo()
		
		// CTTelephonyNetworkInfo is unaware of Wifi connections, always returning a mobile network type or nil
		// Check with reachability first to find wifi connections and shortcut the return.
		if let reachability = try? Reachability.reachabilityForInternetConnection() where reachability.currentReachabilityStatus.description == "WiFi" {
			
			networkResult.connectionType = "WiFi"
			networkResult.success = true
		
		// When there is no wifi connection get the carrier name and connection type
		} else if let carrier = connectionInfo.subscriberCellularProvider?.carrierName, connection = connectionInfo.currentRadioAccessTechnology {
			
			networkResult.carrierName = carrier
			networkResult.connectionType = connection
			
			// Private API, implementation of signal strength reporting for a future date.
			// networkResult.cellID =
			
			networkResult.success = true
		
		// If the currentRadioAccessTechnology value is nil and we're not on wifi then we have no signal at all.
		} else {
			networkResult.comment = "Failed to get connection data!"
			print("Failed to get network data!")
		}
		
		// Return the NetworkResult object to the delegate
		delegate.didFinishNetwork(self, result: networkResult)
	}
}
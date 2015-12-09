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
		
		networkResult.datetime = NSDate().timeIntervalSince1970
		networkResult.testID = "\(id.deviceID)/\(networkResult.datetime)"
		networkResult.parentID = id.parentID
		
		let connectionInfo = CTTelephonyNetworkInfo()
		
		if let reachability = try? Reachability.reachabilityForInternetConnection() where reachability.currentReachabilityStatus.description == "WiFi" {
			
			networkResult.connectionType = "WiFi"
			networkResult.success = true
			print("Network successful! Connection type: WiFi")
			
		} else if let carrier = connectionInfo.subscriberCellularProvider?.carrierName, connection = connectionInfo.currentRadioAccessTechnology {
			
			networkResult.carrierName = carrier
			networkResult.connectionType = connection
			// networkResult.cellID =
			
			networkResult.success = true
			print("Network successful! Carrier: \(carrier) Connection type: \(connection)")
			
		} else {
			networkResult.comment = "Failed to get connection data!"
			print("Failed to get network data!")
		}
		
		delegate.didFinishNetwork(self, result: networkResult)
	}
}
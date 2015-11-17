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
	weak var parent: TestManager?
	
	var networkResult: NetworkResult?
	
	func network(delegateObject: TestManager) {
		self.delegate = delegateObject
		self.parent = delegateObject
		
		self.networkResult = NetworkResult()
		self.networkResult?.datetime = NSDate().timeIntervalSince1970
		self.networkResult?.testID = "\(self.parent?.testMasterResult?.deviceID)" + "\(self.networkResult?.datetime)"
		self.networkResult?.parentID = self.parent?.testMasterResult?.testID
		
		let netInfo = CTTelephonyNetworkInfo()
		
		self.networkResult?.carrierName = netInfo.subscriberCellularProvider?.carrierName
		self.networkResult?.connectionType = netInfo.currentRadioAccessTechnology!
		// self.networkResult?.cellID =
		
		self.networkResult?.success = true
		
		
	}
}
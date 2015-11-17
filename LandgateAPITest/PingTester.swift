//
//  PingTester.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 17/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import SimplePing

protocol PingTesterDelegate: class {
	func didFinishPing(sender: PingTester, result: PingResult)
}

class PingTester {
	static let sharedInstance = PingTester()
	
	weak var delegate: PingTesterDelegate?
	weak var parent: TestManager?
	
	var pingResult: PingResult?
	
	func ping(delegateObject: TestManager) {
		self.delegate = delegateObject
		self.parent = delegateObject
		
		self.pingResult = PingResult()
		
		self.pingResult?.datetime = NSDate().timeIntervalSince1970
		self.pingResult?.testID = "\(self.parent?.testMasterResult?.deviceID)" + "\(self.pingResult?.datetime)"
		self.pingResult?.parentID = self.parent?.testMasterResult?.testID
		
		let url = "www.google.com.au"
		
		self.pingResult?.pingedURL = url
		
		let pinger = SimplePing(hostname: url)
		pinger.delegate = self
		pinger.start()
		

	}
	
}
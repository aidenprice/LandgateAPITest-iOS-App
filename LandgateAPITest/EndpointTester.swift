//
//  EndpointTester.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 17/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation

protocol EndpointTesterDelegate: class {
	func didFinishEndpoint(sender: EndpointTester, result: EndpointResult)
}

class EndpointTester {
	static let sharedInstance = EndpointTester()
	
	weak var delegate: EndpointTesterDelegate?
	weak var parent: TestManager?
	
	var pingResult: EndpointResult?
	
	func test(delegateObject: TestManager) {
		
	}
}

// NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
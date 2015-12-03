//
//  PingTester.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 17/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation

protocol PingTesterDelegate: class {
	func didFinishPing(sender: PingTester, result: PingResult)
}

class PingTester {
	static let sharedInstance = PingTester()
	
	weak var delegate: PingTesterDelegate?
	
	var pingResult: PingResult?
	
	func ping(delegateObject: TestManager, id: idDetails) throws {
		self.delegate = delegateObject
		self.pingResult = PingResult()
		
		guard let delegate = self.delegate, pingResult = self.pingResult else {
			print("Ping method failed. Missing either a delegateObject or a PingResult")
			throw SubTestError.missingResultObject(reason: "Ping method failed. Missing either a delegateObject or a PingResult")
		}
		
		let urlString = "https://google.com.au"
		pingResult.pingedURL = urlString
		
		let url = NSURL(string: urlString)!
		let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
		let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 10.0)
		request.HTTPMethod = HTTPMethod.head.rawValue
		
		let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionConfig)
		
		pingResult.datetime = NSDate().timeIntervalSince1970
		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			if let httpError = error {
				pingResult.comment? += httpError.localizedDescription
				print("Ping error; \(httpError.localizedDescription)")
				
			} else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode >= 400 {
				pingResult.comment? += NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
				print("Ping error; \(NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))")
				
			} else {
				pingResult.pingTime.value = NSDate().timeIntervalSince1970 - pingResult.datetime
				print("Ping successful! Time; \(self.pingResult?.pingTime.value)")
				pingResult.success = true
				
			}
			
			pingResult.testID = "\(id.deviceID)" + "\(pingResult.datetime)"
			pingResult.parentID = id.parentID
			
			delegate.didFinishPing(self, result: pingResult)
		}
		
		task.resume()
		
	}
}
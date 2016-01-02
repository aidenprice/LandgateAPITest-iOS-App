//
//  EndpointTester.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 17/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation

protocol EndpointTesterDelegate: class {
	func didFinishEndpoint(sender: EndpointTester, result: EndpointResult, size: Int)
}

class EndpointTester {
	static let sharedInstance = EndpointTester()
	
	weak var delegate: EndpointTesterDelegate?
	
	var endpointResult: EndpointResult?
	
	func test(delegateObject: TestManager, id: idDetails, endpoint: TETemplate) throws {
		self.delegate = delegateObject
		self.endpointResult = EndpointResult()
		
		guard let delegate = self.delegate, endpointResult = self.endpointResult else {
			print("Test method on EnpointTester failed. Missing either a delegateObject or an EndpointResult")
			throw SubTestError.missingResultObject(reason: "Test method on EndpointTester failed. Missing either a delegateObject or an EndpointResult")
		}
		
		endpointResult.datetime = NSDate().timeIntervalSince1970
		endpointResult.testID = "\(id.deviceID)/\(endpointResult.datetime)"
		endpointResult.parentID = id.parentID
		endpointResult.testedURL = endpoint.url
		
		let url = NSURL(string: endpoint.url)!
		let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
		let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 30.0)
		request.HTTPMethod = endpoint.method.rawValue
		
		if let body = endpoint.body,
		   let data = body.dataUsingEncoding(NSUTF8StringEncoding) {
			print("Adding body to HTTP request")
			print(body)
			print(data)
			request.HTTPBody = data
		}
		
		let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionConfig)
		
		endpointResult.startDatetime = NSDate().timeIntervalSince1970
		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			endpointResult.finishDatetime = NSDate().timeIntervalSince1970
			
			guard error == nil else {
				let httpError = error!
				print("Endpoint test error; \(httpError.localizedDescription)")
				endpointResult.errorResponse = httpError.localizedDescription
				
				if let reason = httpError.localizedFailureReason {
					print("Endpoint test failure reason: \(reason)")
					endpointResult.errorResponse += "\n\(reason)"
				}
				
				delegate.didFinishEndpoint(self, result: endpointResult, size: 0)
				return
			}
				
			guard let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 else {
				let httpResponse = response as! NSHTTPURLResponse
				print("Endpoint test error; \(NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))")
				endpointResult.errorResponse = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
				endpointResult.responseCode = httpResponse.statusCode
				
				delegate.didFinishEndpoint(self, result: endpointResult, size: 0)
				return
			}
			
			print("Endpoint test successful! Response time; \(endpointResult.finishDatetime - endpointResult.startDatetime)")
			endpointResult.success = true
			endpointResult.responseCode = httpResponse.statusCode
			endpointResult.responseData = data
			
			delegate.didFinishEndpoint(self, result: endpointResult, size: data!.length)
		}
		
		task.resume()
	}
}

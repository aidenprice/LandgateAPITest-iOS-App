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
		endpointResult.server = endpoint.server.rawValue
		endpointResult.dataset = endpoint.dataset.rawValue
		endpointResult.returnType = endpoint.returnType.rawValue
		endpointResult.testName = endpoint.testName.rawValue
		endpointResult.httpMethod = endpoint.method.rawValue
		
		guard var url = NSURL(string: endpoint.url) else { return }
		
		if let urlParams = endpoint.urlParams {
			print("Adding URL parameters to request")
			url = url.URLByAppendingQueryParameters(urlParams)
		}
		
		let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
		let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 30.0)
		request.HTTPMethod = endpoint.method.rawValue
		
		if let header = endpoint.header {
			print("Adding headers to request")
			for (headerField, value) in header {
				request.addValue(value, forHTTPHeaderField: headerField)
			}
		}
		
		if let body = endpoint.bodyString {
			print("Adding XML body to HTTP request")
			request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
			
		} else if let body = endpoint.bodyForm {
			print("Adding Form-encoded body to HTTP request")
			let bodyString = body.queryParameters
			request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
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

// MARK: - Helper Functions

// The following code borrowed from Paw HTTP Client examples, and quite well thoughtout it is too.

protocol URLQueryParameterStringConvertible {
	var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
	/**
	This computed property returns a query parameters string from the given NSDictionary. For
	example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
	string will be @"day=Tuesday&month=January".
	@return The computed parameters string.
	*/
	var queryParameters: String {
		var parts: [String] = []
		for (key, value) in self {
			let part = NSString(format: "%@=%@",
				String(key).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
				String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
			parts.append(part as String)
		}
		return parts.joinWithSeparator("&")
	}
}

extension NSURL {
	/**
	Creates a new URL by adding the given query parameters.
	@param parametersDictionary The query parameter dictionary to add.
	@return A new NSURL.
	*/
	func URLByAppendingQueryParameters(parametersDictionary : Dictionary<String, String>) -> NSURL {
		let URLString : NSString = NSString(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
		return NSURL(string: URLString as String)!
	}
}




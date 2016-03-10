//
//  ResultObjects.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 14/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

// MARK: Model classes

/**
	ResultObject is the base class from which others inherit, provides properties common to all classes.
*/
class ResultObject: Object {
	dynamic var testID: String = ""
	dynamic var parentID: String = ""
	dynamic var datetime: Double = 0.0
	dynamic var success: Bool = false
	dynamic var comment: String = ""
	dynamic var uploaded: Bool = false
	
	override static func primaryKey() -> String? {
		return "testID"
	}
}

class TestMasterResult: ResultObject {
	dynamic var startDatetime: Double = 0.0
	dynamic var finishDatetime: Double = 0.0
	dynamic var deviceType: String = ""
	dynamic var deviceID: String = ""
	dynamic var iOSVersion: String = ""
	let endpointResults = List<EndpointResult>()
	let networkResults = List<NetworkResult>()
	let locationResults = List<LocationResult>()
	let pingResults = List<PingResult>()
}

class EndpointResult: ResultObject {
	dynamic var startDatetime: Double = 0.0
	dynamic var finishDatetime: Double = 0.0
	dynamic var server: String = ""
	dynamic var dataset: String = ""
	dynamic var returnType: String = ""
	dynamic var testName: String = ""
	dynamic var httpMethod: String = ""
	dynamic var testedURL: String = ""
	dynamic var responseCode: Int = 0
	dynamic var errorResponse: String = ""
	dynamic var responseData: NSData?
}

class NetworkResult: ResultObject {
	dynamic var connectionType: String = ""
	dynamic var carrierName: String = ""
	dynamic var cellID: String = ""
}

class LocationResult: ResultObject {
	dynamic var latitude: Double = 0.0
	dynamic var longitude: Double = 0.0
}

class PingResult: ResultObject {
	dynamic var pingedURL: String = ""
	dynamic var pingTime: Double = 0.0
}

// MARK: toDict Extension

extension Object {
	/**
	An extension to Realm Object base class to recursively convert any class to a dictionary to be later transformed to a JSON array.
	Checks the NSData responseData property looking for images which it converts to base64 text.
	*/
	func toDict() -> NSDictionary {
		let properties = self.objectSchema.properties.map{ $0.name }.filter{ !(["responseData", "uploaded"].contains($0)) }
		let dictionary = self.dictionaryWithValuesForKeys(properties)
		
		let mutableDict = NSMutableDictionary()
		mutableDict.setValuesForKeysWithDictionary(dictionary)
		
		for prop in self.objectSchema.properties as [Property]! {
			// If the property is the uploaded flag, skip it as anything in the Google App Engine database is obviously uploaded!
			guard prop.name != "uploaded" else {
				continue
			}
			
			// Find empty responses, these will be optionals resolving to nil, then assign them empty strings for the JSON upload dict.
			guard self[prop.name] != nil else {
				print("Nil response found, assigning empty string in its place.")
				mutableDict.setValue("", forKey: prop.name)
				continue
			}
			
			// If the property is responseData skip over it to prevent the statement dumping the NSData byte buffer into the JSON and crashing the app on upload.
			guard prop.name != "responseData" else {
				// Response data could be an image or a JSON or XML string, determine which it is, convert to string and append to JSON upload dict.
				if let dataObject = self[prop.name] as? NSData {
					
					// if NSData is an image then set the imageResponse key
					if let _: UIImage = UIImage(data: dataObject) {
						mutableDict.setValue(dataObject.base64EncodedStringWithOptions(.Encoding64CharacterLineLength), forKey: "imageResponse")
						
					} else if let string: String = String(data: dataObject, encoding: NSUTF8StringEncoding) {
						// We can not test whether the response is a well formed JSON or XML string using
						// standard libraries as we hope to find responses where transmission was interrupted.
						// The first character is sufficient to determine whether the string is XML or JSON.
						if string.hasPrefix("{") {
							mutableDict.setValue(string, forKey: "jsonResponse")
							
						} else if string.hasPrefix("<") {
							mutableDict.setValue(string, forKey: "xmlResponse")
							
							// If the NSData object converts to a string but doesn't match our simple XML vs JSON test, drop it into
							// a jsonResponse and we'll investigate later.
						} else {
							print("NSData converted to string but doesn't appear to be XML or JSON. Investigate further later on.")
							mutableDict.setValue(string, forKey: "jsonResponse")
						}
					}
				}
				continue
			}
			
			// Every other Realm object is handled recursively.
			if let nestedObject = self[prop.name] as? Object {
				mutableDict.setValue(nestedObject.toDict(), forKey: prop.name)
			
			// If the object is an array of other objects, create a new array and recursively dive into them.
			} else if let nestedListObject = self[prop.name] as? ListBase {
				var objects = [AnyObject]()
				for index in 0..<nestedListObject._rlmArray.count  {
					let object = nestedListObject._rlmArray[index] as AnyObject
					objects.append(object.toDict())
				}
				mutableDict.setObject(objects, forKey: prop.name)
			}
		}
		return mutableDict
	}
}
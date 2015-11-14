//
//  ResultObjects.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 14/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import RealmSwift

class ResultObject: Object {
	dynamic var testID: String = ""
	dynamic var parentID: String? = ""
	dynamic var datetime: Double = 0.0
	dynamic var success: Bool = false
	dynamic var comment: String? = ""
	
	override static func primaryKey() -> String? {
		return "testID"
	}
	
	override static func indexedProperties() -> [String] {
		return ["testID", "parentID"]
	}
}

class TestMasterResult: ResultObject {
	dynamic var startDatetime: Double = 0.0
	dynamic var finishDatetime: Double = 0.0
	dynamic var deviceType: String = ""
	dynamic var iOSVersion: String = ""
	let testEndpointResults = List<TestEndpointResult>()
	let networkResults = List<NetworkResult>()
	let locationResults = List<LocationResult>()
	let pingResults = List<PingResult>()
}

class TestEndpointResult: ResultObject {
	dynamic var startDatetime: Double = 0.0
	dynamic var finishDatetime: Double = 0.0
	dynamic var testedURL: String = ""
	let responseCode = RealmOptional<Int>()
	dynamic var errorResponse: String? = ""
	dynamic var responseData: NSData?
}

class NetworkResult: ResultObject {
	dynamic var connectionType: String = ""
	dynamic var carrierName: String? = ""
	dynamic var cellID: String? = ""
}

class LocationResult: ResultObject {
	let latitude = RealmOptional<Double>()
	let longitude = RealmOptional<Double>()
}

class PingResult: ResultObject {
	dynamic var pingedURL: String = ""
	let pingTime = RealmOptional<Double>()
}

// NSDate().timeIntervalSince1970
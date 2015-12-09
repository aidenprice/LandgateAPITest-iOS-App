//
//  ResultObjects.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 14/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation

//import Realm
import RealmSwift

class ResultObject: Object {
	dynamic var testID: String = ""
	dynamic var parentID: String = ""
	dynamic var datetime: Double = 0.0
	dynamic var success: Bool = false
	dynamic var comment: String = ""
	dynamic var uploaded: Bool = false
	
//	override static func primaryKey() -> String? {
//		return "testID"
//	}
//	
//	override static func indexedProperties() -> [String] {
//		return ["testID", "parentID"]
//	}
}

class TestMasterResult: ResultObject {
	dynamic var startDatetime: Double = 0.0
	dynamic var finishDatetime: Double = 0.0
	dynamic var deviceType: String = ""
	dynamic var iOSVersion: String = ""
	dynamic var deviceID: String = ""
	let endpointResults = List<EndpointResult>()
	let networkResults = List<NetworkResult>()
	let locationResults = List<LocationResult>()
	let pingResults = List<PingResult>()
}

class EndpointResult: ResultObject {
	dynamic var startDatetime: Double = 0.0
	dynamic var finishDatetime: Double = 0.0
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
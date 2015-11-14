//
//  SingletonTestManager.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 8/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import RealmSwift

class TestManager {
	static let sharedInstance = TestManager()
	
	var state
	
	var testPlan: [TestEndpoint]?
	
	var testCampaign: String = "test_campaign"
	
	var testMasterResult: TestMasterResult?
	
	var testResults: [TestResult]?
	
	var locationResults: [LocationResult]?
	
	var connectionResults: [ConnectionResult]?
	
	var pingResults: [PingResult]?
	
}
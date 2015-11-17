//
//  SingletonTestManager.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 8/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import RealmSwift
import Transporter
import UIKit

enum ManagerState {
	case Ready
	case PreTest
	case EndpointTesting
	case Locating
	case Networking
	case Pinging
	case PostTest
}

class TestManager: LocationTesterDelegate, NetworkTesterDelegate, PingTesterDelegate, EndpointTesterDelegate {
	static let sharedInstance = TestManager()
	
	let stateMachine: StateMachine
	
	var testPlan: [TestEndpoint]?
	
	var testCampaign: String = "test_campaign"
	
	var testMasterResult = TestMasterResult()
	var endpointResults = [EndpointResult]()
	var locationResults = [LocationResult]()
	var networkResults = [NetworkResult]()
	var pingResults = [PingResult]()
	
	init() {
		let readyState = State(ManagerState.Ready)
		let preTestState = State(ManagerState.PreTest)
		let endpointTestingState = State(ManagerState.EndpointTesting)
		let locatingState = State(ManagerState.Locating)
		let networkingState = State(ManagerState.Networking)
		let pingingState = State(ManagerState.Pinging)
		let postTestState = State(ManagerState.PostTest)
		
		stateMachine = StateMachine(initialState: readyState, states: [preTestState, endpointTestingState, locatingState, networkingState, pingingState, postTestState])
		
		let prepareForTestEvent = Event(name: "PrepareFotTest", sourceStates: readyState, destinationState: preTestState)
		let startTestEvent = Event(name: "StartTest", sourceStates: preTestState, destinationState: locatingState)
		let networkTestEvent = Event(name: "NetworkTest", sourceStates: locatingState, destinationState: networkingState)
		let pingTestEvent = Event(name: "PingTest", sourceStates: networkingState, destinationState: pingingState)
		let endpointTestEvent = Event(name: "EndpointTest", sourceStates: pingingState, destinationState: endpointTestingState)
		let locationTestEvent = Event(name: "LocationTest", sourceStates: endpointTestingState, destinationState: locatingState)
		let finishTestEvent = Event(name: "FinishTest", sourceStates: pingingState, destinationState: postTestState)
		let unableToTestEvent = Event(name: "UnableToStartTest", sourceStates: preTestState, destinationState: postTestState)
		let backToReadyEvent = Event(name: "ReturnToReadyState", sourceStates: postTestState, destinationState: readyState)
		let abortEvent = Event(name: "Abort", sourceStates: [preTestState, endpointTestingState, locatingState, networkingState, pingingState], destinationState: postTestState)
		
		stateMachine.addEvents([prepareForTestEvent, startTestEvent, networkTestEvent, pingTestEvent, endpointTestEvent, locationTestEvent, finishTestEvent, unableToTestEvent, backToReadyEvent, abortEvent])
		
		readyState.didEnterState = { _ in didEnterReadyState() }
		preTestState.didEnterState = { _ in didEnterPreTestState() }
		endpointTestingState.didEnterState = { _ in didEnterEndpointTestingState() }
		locatingState.didEnterState = { _ in didEnterLocatingState() }
		networkingState.didEnterState = { _ in didEnterNetworkingState() }
		pingingState.didEnterState = { _ in didEnterPingingState() }
		postTestState.didEnterState = { _ in didEnterPostTestState() }
		
	}
	
	func didEnterReadyState() {
		self.testMasterResult = TestMasterResult()
		self.endpointResults.removeAll()
		self.locationResults.removeAll()
		self.networkResults.removeAll()
		self.pingResults.removeAll()
	}
	
	func didEnterPreTestState() {
		let start = NSDate().timeIntervalSince1970
		self.testMasterResult.datetime = start
		self.testMasterResult.startDateTime = start
		self.testMasterResult.deviceID = UIDevice.currentDevice().identifierForVendor
		self.testMasterResult.deviceType = self.platform()
		self.testMasterResult.iOSVersion = UIDevice.currentDevice().systemVersion
		self.testMasterResult.testID = "\(self.testMasterResult.deviceID)" + "\(start)"
		
		if hasConnectivity() {
			self.testMasterResult?.success = true
			
			stateMachine.fireEvent("StartTest")
		} else {
			self.testMasterResult?.comment = "No internet connectivity, aborting test without running any subtests."
			self.testMasterResult?.finishDatetime = NSDate().timeIntervalSince1970
			stateMachine.fireEvent("UnableToStartTest")
		}
	}
	
	func didEnterEndpointTestingState() {
		EndpointTester.sharedInstance.test(delegateObject: self)
	}
	
	func didEnterLocatingState() {
		LocationTester.sharedInstance.locate(delegateObject: self)
	}
	
	func didEnterNetworkingState() {
		NetworkTester.sharedInstance.network(delegateObject: self)
	}
	
	func didEnterPingingState() {
		PingTester.sharedInstance.ping(delegateObject: self)
	}
	
	func didEnterPostTestState() {
		
	}
	
	func didFinishEndpoint(sender: EndpointTester, result: EndpointResult) {
		self.endpointResults.append(result)
		stateMachine.fireEvent("LocationEvent")
	}
	
	func didFinishLocating(sender: LocationTester, result: LocationResult) {
		self.locationResults.append(result)
		stateMachine.fireEvent("NetworkTest")
	}
	
	func didFinishNetwork(sender: NetworkTester, result: NetworkResult) {
		self.networkResults.append(result)
		stateMachine.fireEvent("PingTest")
	}
	
	func didFinishPing(sender: PingTester, result: PingResult) {
		self.pingResults.append(result)
		
		if let self.testPlan = testPlan where !testPlan.isEmpty {
			stateMachine.fireEvent("EndpointTest")
		} else {
			stateMachine.fireEvent("FinishTest")
		}
	}
	
	func hasConnectivity() -> Bool {
		let reachability: Reachability =  Reachability.reachabilityForInternetConnection()
		let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
		return networkStatus != 0
	}
	
	func platform() -> String {
		var sysinfo = utsname()
		uname(&sysinfo) // ignore return value
		return NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: NSASCIIStringEncoding)! as String
	}

}
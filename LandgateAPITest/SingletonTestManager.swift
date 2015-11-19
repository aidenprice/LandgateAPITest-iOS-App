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

protocol TestManagerDelegate: class {
	func didStartTesting()
	
	func didFinishTesting()
	
	func didFailToStartTest(reason: String)
	
	func didFailToInitDefaultRealm(title: String, message: String)
}

enum ManagerState {
	case Ready, PreTest, EndpointTesting, Locating, Networking, Pinging, PostTest
}

struct ManagerEvents {
	static let Prepare = "PrepareFotTest"
	static let Start = "StartTest"
	static let Network = "NetworkTest"
	static let Ping = "PingTest"
	static let Endpoint = "EndpointTest"
	static let Location = "LocationTest"
	static let Finish = "FinishTest"
	static let UnableToStart = "UnableToStartTest"
	static let Ready = "ReturnToReadyState"
	static let Abort = "Abort"
}

class TestManager: LocationTesterDelegate, NetworkTesterDelegate, PingTesterDelegate, EndpointTesterDelegate {
	
	// MARK: Public Interface
	
	static let sharedInstance = TestManager()
	
	var delegate: TestManagerDelegate?
	
	var testPlan: [TETemplate]?
	
	var campaign: String = "test_campaign"
	
	// MARK: Private lazy properties
	
	private lazy var testMasterResult = TestMasterResult()
	
	private lazy var stateMachine: StateMachine<ManagerState> = {
		print("State Machine Started! Check for multiple startups!")
		let readyState = State(ManagerState.Ready)
		let preTestState = State(ManagerState.PreTest)
		let endpointTestingState = State(ManagerState.EndpointTesting)
		let locatingState = State(ManagerState.Locating)
		let networkingState = State(ManagerState.Networking)
		let pingingState = State(ManagerState.Pinging)
		let postTestState = State(ManagerState.PostTest)
		
		readyState.didEnterState = { _ in self.didEnterReadyState() }
		preTestState.didEnterState = { _ in self.didEnterPreTestState() }
		endpointTestingState.didEnterState = { _ in self.didEnterEndpointTestingState() }
		locatingState.didEnterState = { _ in self.didEnterLocatingState() }
		networkingState.didEnterState = { _ in self.didEnterNetworkingState() }
		pingingState.didEnterState = { _ in self.didEnterPingingState() }
		postTestState.didEnterState = { _ in self.didEnterPostTestState() }
		
		let stateMachine = StateMachine(initialState: readyState, states: [preTestState, endpointTestingState, locatingState, networkingState, pingingState, postTestState])
		
		let prepareForTestEvent = Event(name: ManagerEvents.Prepare, sourceStates: [ManagerState.Ready], destinationState: ManagerState.PreTest)
		let startTestEvent = Event(name: ManagerEvents.Start, sourceStates: [ManagerState.PreTest], destinationState: ManagerState.Locating)
		let networkTestEvent = Event(name: ManagerEvents.Network, sourceStates: [ManagerState.Locating], destinationState: ManagerState.Networking)
		let pingTestEvent = Event(name: ManagerEvents.Ping, sourceStates: [ManagerState.Networking], destinationState: ManagerState.Pinging)
		let endpointTestEvent = Event(name: ManagerEvents.Endpoint, sourceStates: [ManagerState.Pinging], destinationState: ManagerState.EndpointTesting)
		let locationTestEvent = Event(name: ManagerEvents.Location, sourceStates: [ManagerState.EndpointTesting], destinationState: ManagerState.Locating)
		let finishTestEvent = Event(name: ManagerEvents.Finish, sourceStates: [ManagerState.Pinging], destinationState: ManagerState.PostTest)
		let unableToTestEvent = Event(name: ManagerEvents.UnableToStart, sourceStates: [ManagerState.PreTest], destinationState: ManagerState.PostTest)
		let backToReadyEvent = Event(name: ManagerEvents.Ready, sourceStates: [ManagerState.PostTest], destinationState: ManagerState.Ready)
		let abortEvent = Event(name: ManagerEvents.Abort, sourceStates: [ManagerState.PreTest, ManagerState.EndpointTesting, ManagerState.Locating, ManagerState.Networking, ManagerState.Pinging], destinationState: ManagerState.PostTest)
		
		stateMachine.addEvents([prepareForTestEvent, startTestEvent, networkTestEvent, pingTestEvent, endpointTestEvent, locationTestEvent, finishTestEvent, unableToTestEvent, backToReadyEvent, abortEvent])
		print(stateMachine)
		return stateMachine
	}()
	
	private lazy var realm: Realm = {
		print("Realm started! Check for multiple startups!")
		let testRealm: Realm
		do {
			try testRealm = Realm()
			print("Using default Realm")
		}
		catch {
			self.delegate?.didFailToInitDefaultRealm("Data storage error!", message: "The app is unable to save your test data to disk. We'll save data in memory to allow you to upload it but it will not persist between app launches. Thank you!")
			
			try! testRealm = Realm(configuration: Realm.Configuration(inMemoryIdentifier: "InMemoryRealm"))
			print("Using In Memory Realm")
		}
		print(testRealm)
		return testRealm
	}()

	// MARK: State Change Methods
	
	func didEnterReadyState() {
		print("Entered Ready state")
		self.testMasterResult = TestMasterResult()
	}
	
	func didEnterPreTestState() {
		print("Entered Pretest state")
		let start = NSDate().timeIntervalSince1970
		self.testMasterResult.datetime = start
		self.testMasterResult.startDatetime = start
		self.testMasterResult.deviceID = (UIDevice.currentDevice().identifierForVendor?.description)!
		self.testMasterResult.deviceType = self.platform()
		self.testMasterResult.iOSVersion = UIDevice.currentDevice().systemVersion
		self.testMasterResult.testID = "\(self.testMasterResult.deviceID)" + "\(start)"
		
		if hasConnectivity() {
			self.testMasterResult.success = true
			stateMachine.fireEvent("StartTest")
		} else {
			self.testMasterResult.comment? += "\nNo internet connectivity, aborting test without running any subtests.\n"
			self.testMasterResult.finishDatetime = NSDate().timeIntervalSince1970
			stateMachine.fireEvent("UnableToStartTest")
		}
	}
	
	func didEnterEndpointTestingState() {
		print("Entered Endpoint Test state")
		if var remainingTests = self.testPlan where !remainingTests.isEmpty {
			print("\(self.testPlan!.count)" + " items in self.testPlan before pop operation.")
			EndpointTester.sharedInstance.test(self, endpoint: remainingTests.removeLast())
			print("\(remainingTests.count)" + " items left in remainingTests. Check for inconsistent counts.")
		} else {
			print("Aborting due to an empty testPlan array. How did we end up here? The didFinishPing() method should handle this!")
			stateMachine.fireEvent("Abort")
		}
	}
	
	func didEnterLocatingState() {
		print("Entered Location Test state")
		LocationTester.sharedInstance.locate(self)
	}
	
	func didEnterNetworkingState() {
		print("Entered Network Test state")
		NetworkTester.sharedInstance.network(self)
	}
	
	func didEnterPingingState() {
		print("Entered Ping Test state")
		PingTester.sharedInstance.ping(self)
	}
	
	func didEnterPostTestState() {
		print("Entered Post Test state")
		self.testMasterResult.finishDatetime = NSDate().timeIntervalSince1970
		
		try! realm.write({ _ in
			self.realm.add(self.testMasterResult)
		})
	}
	
	// MARK: Delegate event methods
	
	func didFinishEndpoint(sender: EndpointTester, result: EndpointResult) {
		self.testMasterResult.endpointResults.append(result)
		stateMachine.fireEvent(ManagerEvents.Location)
	}
	
	func didFinishLocating(sender: LocationTester, result: LocationResult) {
		self.testMasterResult.locationResults.append(result)
		stateMachine.fireEvent(ManagerEvents.Network)
	}
	
	func didFinishNetwork(sender: NetworkTester, result: NetworkResult) {
		self.testMasterResult.networkResults.append(result)
		stateMachine.fireEvent(ManagerEvents.Ping)
	}
	
	func didFinishPing(sender: PingTester, result: PingResult) {
		self.testMasterResult.pingResults.append(result)
		
		if let remainingTests = self.testPlan where !remainingTests.isEmpty {
			stateMachine.fireEvent(ManagerEvents.Endpoint)
		} else {
			stateMachine.fireEvent(ManagerEvents.Finish)
		}
	}
	
	// MARK: Helper methods
	
	func hasConnectivity() -> Bool {
		do {
			let reachability: Reachability =  try Reachability.reachabilityForInternetConnection()
			let networkStatus: String = reachability.currentReachabilityStatus.description
			return networkStatus != "No Connection"
		} catch {
			return false
		}
	}
	
	func platform() -> String {
		var sysinfo = utsname()
		uname(&sysinfo) // ignore return value
		return NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: NSASCIIStringEncoding)! as String
	}

}
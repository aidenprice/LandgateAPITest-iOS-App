//
//  SingletonTestManager.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 8/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import UIKit

import RealmSwift
import Transporter

struct idDetails {
	let parentID: String
	let deviceID: String
}

enum SubTestError: ErrorType {
	case missingResultObject(reason: String)
}

enum TestManagerError: ErrorType {
	case missingTestMasterResultObject(reason: String)
	case subtestFailure(reason: String)
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

protocol TestManagerDelegate: class {
	
	func didStartTesting()
	
	func didFailToStartTest(reason: String)
	
	func didFailToInitDefaultRealm(title: String, message: String)
	
	func didFailWithError(reason: String)
}

protocol TestManagerProgressDelegate: class {
	
	func progressReport(progress: Double)
	
	func didFinishTesting(testID: String)
	
	func didFailWithError(reason: String)
	
}

class TestManager: LocationTesterDelegate, NetworkTesterDelegate, PingTesterDelegate, EndpointTesterDelegate {
	
	// MARK: Public Interface
	
	static let sharedInstance = TestManager()
	
	var delegate: TestManagerDelegate?
	
	var progressDelegate: TestManagerProgressDelegate?
	
	var originalTestCount: Int?
	var progressTarget: Double?
	
	var testPlan: [TETemplate]? {
		didSet(newPlan) {
			guard let plan = newPlan where plan.count > 0 else { return }
			
			print("New Plan! Count: \(plan.count)")
			
			self.originalTestCount = plan.count
			self.progressTarget = Double((plan.count * 4) + 3)
			
			print("Total tests to perform: \(progressTarget)")
			self.stateMachine.fireEvent(ManagerEvents.Prepare)
		}
	}
	
	var campaign: String = "test_campaign"
	
	lazy var testMasterResult: TestMasterResult? = TestMasterResult()
	
	lazy var stateMachine: StateMachine<ManagerState> = {
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
	
	lazy var realm: Realm = {
		print("Realm started! Check for multiple startups!")
		let testRealm: Realm
		do {
			try testRealm = Realm()
			print("Using default Realm")
		
		} catch {
			self.delegate?.didFailToInitDefaultRealm("Data storage error!", message: "The app is unable to save your test data to disk. We'll save data in memory to allow you to upload it but it will not persist between app launches. Thank you!")
			
			try! testRealm = Realm(configuration: Realm.Configuration(inMemoryIdentifier: "InMemoryRealm"))
			print("Using In Memory Realm")
			
		}
		print(testRealm)
		return testRealm
	}()
	
	func startWithTestPlan(testplan: [TETemplate]) -> TestManager {
		
		self.testPlan = testplan
		
		return TestManager.sharedInstance
	}

	// MARK: State Change Methods
	
	func didEnterReadyState() {
		print("Entered Ready state")
		self.testMasterResult = TestMasterResult()
	}
	
	func didEnterPreTestState() {
		print("Entered Pretest state")
		
		guard let testMasterResult = self.testMasterResult else {
			stateMachine.fireEvent(ManagerEvents.UnableToStart)
			return
		}
		
		let start = NSDate().timeIntervalSince1970
		testMasterResult.datetime = start
		testMasterResult.startDatetime = start
		testMasterResult.deviceID = (UIDevice.currentDevice().identifierForVendor?.description)!
		testMasterResult.deviceType = self.platform()
		testMasterResult.iOSVersion = UIDevice.currentDevice().systemVersion
		testMasterResult.testID = "\(testMasterResult.deviceID)" + "\(start)"
		
		if hasConnectivity() {
			testMasterResult.success = true
			
			self.delegate?.didStartTesting()
			stateMachine.fireEvent(ManagerEvents.Start)
			
		} else {
			testMasterResult.finishDatetime = NSDate().timeIntervalSince1970
			testMasterResult.comment? += "\nNo internet connectivity, aborting test without running any subtests.\n"
			
			self.delegate?.didFailToStartTest("Unable to connect to the internet. Are you outside mobile range entirely?")
			stateMachine.fireEvent(ManagerEvents.UnableToStart)
		}
	}
	
	func didEnterEndpointTestingState() {
		print("Entered Endpoint Test state")
		
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing TestMasterResult object.")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		if let remainingTests = self.testPlan where !remainingTests.isEmpty {
			print("\(self.testPlan!.count)" + " items in self.testPlan before pop operation.")
			
			let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
			
			do {
				try EndpointTester.sharedInstance.test(self, id: id, endpoint: (self.testPlan?.removeLast())!)
				
//				self.testPlan = remainingTests
				
			} catch {
				self.progressDelegate?.didFailWithError("Endpoint test error!")
				print("Aborting due to error condition")
				stateMachine.fireEvent(ManagerEvents.Abort)
			}
			
			print("\(self.testPlan!.count)" + " items in self.testPlan after pop operation.")
			print("\(remainingTests.count)" + " items left in remainingTests. Check for inconsistent counts.")
			
		} else {
			print("Aborting due to an empty testPlan array. How did we end up here? The didFinishPing() method should handle this!")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	func didEnterLocatingState() {
		print("Entered Location Test state")
		
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing testMasterResult object error!")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
		
		do {
			try LocationTester.sharedInstance.locate(self, id: id)
			
		} catch {
			self.progressDelegate?.didFailWithError("Location test error!")
			print("Aborting due to error condition")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	func didEnterNetworkingState() {
		print("Entered Network Test state")
		
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing testMasterResult object error!")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
		
		do {
			try NetworkTester.sharedInstance.network(self, id: id)
			
		} catch {
			self.progressDelegate?.didFailWithError("Network test error!")
			print("Aborting due to error condition")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	func didEnterPingingState() {
		print("Entered Ping Test state")
		
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing testMasterResult object error!")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
		
		do {
			try PingTester.sharedInstance.ping(self, id: id)
		} catch {
			self.progressDelegate?.didFailWithError("Ping test error!")
			print("Aborting due to error condition")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	func didEnterPostTestState() {
		print("Entered Post Test state")
		
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object in PostTestState.")
			self.progressDelegate?.didFailWithError("Missing testMasterResult object in PostTestState error!")
			stateMachine.fireEvent(ManagerEvents.Ready)
			return
		}
		
		testMasterResult.finishDatetime = NSDate().timeIntervalSince1970
		
		do {
			try realm.write({ _ in self.realm.add(testMasterResult) })
			print("Writing to Realm store.")
		} catch {
			self.delegate?.didFailWithError("Unable to write TestMasterResult object to Realm persistent storage!")
		}
		
		self.progressDelegate?.didFinishTesting(testMasterResult.testID)
		stateMachine.fireEvent(ManagerEvents.Ready)
	}
	
	// MARK: Delegate event methods
	
	func didFinishEndpoint(sender: EndpointTester, result: EndpointResult) {
		print("Finished testing endpoint!")
		self.testMasterResult!.endpointResults.append(result)
		
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count,
			let originalTests = self.originalTestCount,
			let target = self.progressTarget {
		
			let progress = Double(abs(remainingTests - originalTests) * 4) / target
			
			progressDelegate.progressReport(progress)
		}
		
		stateMachine.fireEvent(ManagerEvents.Location)
	}
	
	func didFinishLocating(sender: LocationTester, result: LocationResult) {
		print("Finished testing location!")
		self.testMasterResult!.locationResults.append(result)
		
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count,
			let originalTests = self.originalTestCount,
			let target = self.progressTarget {
				
				let progress = Double((abs(remainingTests - originalTests) * 4) + 1) / target
				
				progressDelegate.progressReport(progress)
		}
		
		stateMachine.fireEvent(ManagerEvents.Network)
	}
	
	func didFinishNetwork(sender: NetworkTester, result: NetworkResult) {
		print("Finished testing network!")
		self.testMasterResult!.networkResults.append(result)
		
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count,
			let originalTests = self.originalTestCount,
			let target = self.progressTarget {
				
				let progress = Double((abs(remainingTests - originalTests) * 4) + 2) / target
				
				progressDelegate.progressReport(progress)
		}
		
		stateMachine.fireEvent(ManagerEvents.Ping)
	}
	
	func didFinishPing(sender: PingTester, result: PingResult) {
		print("Finished ping test!")
		self.testMasterResult!.pingResults.append(result)
		
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count,
			let originalTests = self.originalTestCount,
			let target = self.progressTarget {
				
				let progress = Double((abs(remainingTests - originalTests) * 4) + 3) / target
				
				progressDelegate.progressReport(progress)
		}
		
		if let remainingTests = self.testPlan where !remainingTests.isEmpty {
			print("Still endpoint tests yet to be run!")
			stateMachine.fireEvent(ManagerEvents.Endpoint)
		} else {
			print("Finished all endpoints, heading to PostTestState!")
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
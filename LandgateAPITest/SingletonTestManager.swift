//
//  SingletonTestManager.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 8/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import Transporter

// MARK: Constants

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
	static let Awake = "Awake"
}

// MARK: Delegate Protocols

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

// MARK: Enums

// Error type enumerations
enum SubTestError: ErrorType {
	case missingResultObject(reason: String)
}

enum TestManagerError: ErrorType {
	case missingTestMasterResultObject(reason: String)
	case subtestFailure(reason: String)
}

// Test Manager states enumeration
enum ManagerState {
	case Ready, PreTest, EndpointTesting, Locating, Networking, Pinging, PostTest
}

// A small struct to hold ID details to pass in to a sub-test manager.
struct idDetails {
	let parentID: String
	let deviceID: String
}

// MARK: TestManager Singleton

/** 
Test Manager Singleton.
The workhorse of the application, loops through testing states firing tests sequentially
and squaring away the results at the end of testing. */
class TestManager: LocationTesterDelegate, NetworkTesterDelegate, PingTesterDelegate, EndpointTesterDelegate {
	
	// Singleton constructor.
	static let sharedInstance = TestManager()
	
	var delegate: TestManagerDelegate?
	
	var progressDelegate: TestManagerProgressDelegate?
	
	// The key linking multiple Test Master results in a single over-arching campaign.
	var campaign: String = "production_campaign"
	
	var testMasterResult: TestMasterResult?
	
	let stateMachine: StateMachine<ManagerState>
	
	let realm: Realm
	
	var downloadTotal: Int = 0
	
	// Properties for the progress delegate to determine percent completion.
	var originalTestCount: Int = 0
	var progressTarget: Double = 0.0
	
	// Determines whether the testPlan is newly assigned.
	// Prevents testPlan's didSet logic from firing each time a test is popped off the array.
	var isNewPlan: Bool = false
	
	var testPlan: [TETemplate]? {
		// When the testPlan property receives a new array fire up the state machine.
		// Only fire when the plan is first set, not when each test is popped off the array, controlled with the isNewPlan propety.
		didSet {
			guard let plan = self.testPlan where !plan.isEmpty && self.isNewPlan == true else { return }
			
			print("New Plan! Count: \(plan.count)")
			
			// Properties for the progress delegate to determine percent completion.
			self.originalTestCount = plan.count
			self.progressTarget = Double((plan.count * 4) + 3)
			
			print("Total tests to perform: \(progressTarget)")
			self.stateMachine.fireEvent(ManagerEvents.Prepare)
			
			self.isNewPlan = false
		}
	}
	
	// MARK: Init Methods
	
	init() {
		print("State Machine Started!")
		
		// State machine states...
		let readyState = State(ManagerState.Ready)
		let preTestState = State(ManagerState.PreTest)
		let endpointTestingState = State(ManagerState.EndpointTesting)
		let locatingState = State(ManagerState.Locating)
		let networkingState = State(ManagerState.Networking)
		let pingingState = State(ManagerState.Pinging)
		let postTestState = State(ManagerState.PostTest)
		
		let stateMachine = StateMachine(initialState: readyState, states: [preTestState, endpointTestingState, locatingState, networkingState, pingingState, postTestState])
		
		// State machine events to force state change
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
		let awakeEvent = Event(name: ManagerEvents.Awake, sourceStates: [ManagerState.PreTest, ManagerState.EndpointTesting, ManagerState.Locating, ManagerState.Networking, ManagerState.Pinging, ManagerState.PostTest, ManagerState.Ready], destinationState: ManagerState.Ready)
		
		stateMachine.addEvents([prepareForTestEvent, startTestEvent, networkTestEvent, pingTestEvent, endpointTestEvent, locationTestEvent, finishTestEvent, unableToTestEvent, backToReadyEvent, abortEvent, awakeEvent])
		
		self.stateMachine = stateMachine
		
		// Realm database wake up call, prompt user if database not found and default to in memory tables.
		var testRealm: Realm? = nil
		do {
			try testRealm = Realm()
			print("Using default Realm")
			
		} catch {
			self.delegate?.didFailToInitDefaultRealm("Data storage error!", message: "The app is unable to save your test data to disk. We'll save data in memory to allow you to upload it but it will not persist between app launches. Thank you!")
			
			try! testRealm = Realm(configuration: Realm.Configuration(inMemoryIdentifier: "InMemoryRealm"))
			print("Using In Memory Realm")
		}
		self.realm = testRealm!
		
		// Assign functions to state change events. For some reason this had to be assigned after the processor had been off on some other task.
		readyState.didEnterState = { _ in self.didEnterReadyState() }
		preTestState.didEnterState = { _ in self.didEnterPreTestState() }
		endpointTestingState.didEnterState = { _ in self.didEnterEndpointTestingState() }
		locatingState.didEnterState = { _ in self.didEnterLocatingState() }
		networkingState.didEnterState = { _ in self.didEnterNetworkingState() }
		pingingState.didEnterState = { _ in self.didEnterPingingState() }
		postTestState.didEnterState = { _ in self.didEnterPostTestState() }
		
	}
	
	// MARK: Public API
	
	// Other modules may also fire events, though in theory the manager could ignore them.
	
	func startWithTestPlan(plan: [TETemplate]) {
		// On receiving a new plan of endpoint tests start the process.
		self.isNewPlan = true
		self.testPlan = plan
		
	}

	// MARK: State Change Methods
	
	private func didEnterReadyState() {
		print("Entered Ready state")
	}
	
	private func didEnterPreTestState() {
		print("Entered Pretest state")
		
		self.testMasterResult = TestMasterResult()
		
		// Fail out of the routine if there is no test master result object to write results.
		guard let testMasterResult = self.testMasterResult else {
			stateMachine.fireEvent(ManagerEvents.UnableToStart)
			return
		}
		
		// Write basic properties for a Test Master result object.
		let start = NSDate().timeIntervalSince1970
		testMasterResult.datetime = start
		print("Start time: \(start)")
		testMasterResult.startDatetime = start
		testMasterResult.deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
		print("Device ID: \(testMasterResult.deviceID)")
		testMasterResult.deviceType = self.platform()
		testMasterResult.iOSVersion = UIDevice.currentDevice().systemVersion
		testMasterResult.testID = "\(testMasterResult.deviceID)/\(start)"
		print("Test ID: \(testMasterResult.testID)")
		
		// Test for internet connectivity at the outset, fail entirely if no connection at all so as to avoid wasting time and battery.
		if hasConnectivity() {
			testMasterResult.success = true
			print("didStartTesting about to be called on delegate: \(self.delegate)")
			self.delegate?.didStartTesting()
			stateMachine.fireEvent(ManagerEvents.Start)
			
		} else {
			testMasterResult.finishDatetime = NSDate().timeIntervalSince1970
			testMasterResult.comment += "\nNo internet connectivity, aborting test without running any subtests.\n"
			
			self.delegate?.didFailToStartTest("Unable to connect to the internet. Are you outside mobile range entirely?")
			stateMachine.fireEvent(ManagerEvents.UnableToStart)
		}
	}
	
	private func didEnterEndpointTestingState() {
		print("Entered Endpoint Test state")
		
		// Fail out of the test if no Test Master result object to store EndpointTest result.
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing TestMasterResult object.")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		if let remainingTests = self.testPlan where !remainingTests.isEmpty {
			print("\(self.testPlan!.count)" + " items in self.testPlan before pop operation.")
			
			// Create a test ID object to identify the test and its parent Test Master.
			let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
			
			// Pop the top test off the array, cancel the test if we got this far but couldn't get a test off the array.
			do {
				try EndpointTester.sharedInstance.test(self, id: id, endpoint: (self.testPlan?.removeLast())!)
				
			} catch {
				self.progressDelegate?.didFailWithError("Endpoint test error!")
				print("Aborting due to error condition")
				stateMachine.fireEvent(ManagerEvents.Abort)
			}
			
			print("\(self.testPlan!.count)" + " items in self.testPlan after pop operation.")
			
		} else {
			// An absolute worst case default condition, really shouldn't end up here.
			print("Aborting due to an empty testPlan array. How did we end up here? The didFinishPing() method should handle this!")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	private func didEnterLocatingState() {
		print("Entered Location Test state")
		
		// Cancel everything if there's no Test Master result object to store the result.
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing testMasterResult object error!")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
		
		// Conduct location test, the delegate method will call back when it's done.
		do {
			try LocationTester.sharedInstance.locate(self, id: id)
			
		} catch {
			self.progressDelegate?.didFailWithError("Location test error!")
			print("Aborting due to error condition")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	private func didEnterNetworkingState() {
		print("Entered Network Test state")
		
		// Cancel everything if there's no Test Master to store the result.
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing testMasterResult object error!")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
		
		// Test network connection type and carrier.
		do {
			try NetworkTester.sharedInstance.network(self, id: id)
			
		} catch {
			self.progressDelegate?.didFailWithError("Network test error!")
			print("Aborting due to error condition")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	private func didEnterPingingState() {
		print("Entered Ping Test state")
		
		// Cancel everything if there's no Test Master result object to store the ping result.
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object.")
			self.progressDelegate?.didFailWithError("Missing testMasterResult object error!")
			stateMachine.fireEvent(ManagerEvents.Abort)
			return
		}
		
		let id = idDetails(parentID: testMasterResult.testID, deviceID: testMasterResult.deviceID)
		
		// Ping google.com.au with a HEAD request and time.
		do {
			try PingTester.sharedInstance.ping(self, id: id)
		} catch {
			self.progressDelegate?.didFailWithError("Ping test error!")
			print("Aborting due to error condition")
			stateMachine.fireEvent(ManagerEvents.Abort)
		}
	}
	
	private func didEnterPostTestState() {
		print("Entered Post Test state")
		
		// Get the delegate to send progress updates.
		guard let progressDelegate = self.progressDelegate else {
			return
		}
		
		// Get the Test Master result object.
		guard let testMasterResult = self.testMasterResult else {
			print("Missing TestMasterResult object in PostTestState.")
			progressDelegate.didFailWithError("Missing testMasterResult object in PostTestState error!")
			stateMachine.fireEvent(ManagerEvents.Ready)
			return
		}
		
		// Assign a finish time for the whole Test Master, not just the smaller sub-tests.
		testMasterResult.finishDatetime = NSDate().timeIntervalSince1970
		
		// Write the whole Test Master, along with all sub-tests in their arrays, to the Realm database.
		do {
			let writeRealm = try Realm()
			try writeRealm.write {
				writeRealm.add(testMasterResult)
			}
			print("testMasterResult write complete!")
			
		} catch {
			print("Can't write testMasterResult to Realm!")
			progressDelegate.didFailWithError("Unable to write TestMasterResult object to Realm persistent storage!")
		}
		
		print("Final download size \(self.downloadTotal)")
		
		// Update progress delegate to 100% complete.
		progressDelegate.progressReport(1.0)
		progressDelegate.didFinishTesting(testMasterResult.testID)
		
		// Return the state machine to the ready state.
		stateMachine.fireEvent(ManagerEvents.Ready)
	}
	
	// MARK: Delegate Event Methods
	
	func didFinishEndpoint(sender: EndpointTester, result: EndpointResult, size: Int) {
		print("Finished testing endpoint!")
		
		// Get the Test Master result object, but only if the state machine is testing endpoints.
		// This stops conflicts of trying to move between states incorrectly, i.e. moving in the wrong sequence.
		guard let testMasterResult = self.testMasterResult where self.stateMachine.isInState(ManagerState.EndpointTesting) else {
			print("There's either no testMasterResult or we're not in the EndpointTesting state anymore! No actions taken, nothing saved.")
			return
		}
		
		// Add the endpoint result to the Test Master's array.
		testMasterResult.endpointResults.append(result)
		
		self.downloadTotal += size
		print("Download size thus far: \(self.downloadTotal)")
		
		// Update the progress delegate to change the UI.
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count {
		
			let progress = Double(abs(remainingTests - self.originalTestCount) * 4) / self.progressTarget
			
			progressDelegate.progressReport(progress)
		}
		
		// Fire the event to call the next test state, location in this case.
		stateMachine.fireEvent(ManagerEvents.Location)
	}
	
	func didFinishLocating(sender: LocationTester, result: LocationResult) {
		print("Finished testing location!")
		
		// Get the Test Master result object, but only if we're currently locating the device. 
		//This prevents double location results, actually a noticeable problem in this app of unknown cause.
		guard let testMasterResult = self.testMasterResult where self.stateMachine.isInState(ManagerState.Locating) else {
			print("There's either no testMasterResult or we're not in the Locating state anymore! No actions taken, nothing saved.")
			return
		}
		
		// Add the location to the Test Master's location array.
		testMasterResult.locationResults.append(result)
		
		// Update the progress delegate to update the UI.
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count {
				
				let progress = Double((abs(remainingTests - self.originalTestCount) * 4) + 1) / self.progressTarget
				
				progressDelegate.progressReport(progress)
		}
		
		// Fire the event to call the next test state, network tests in this case.
		stateMachine.fireEvent(ManagerEvents.Network)
	}
	
	func didFinishNetwork(sender: NetworkTester, result: NetworkResult) {
		print("Finished testing network!")
		
		// Get the Test Master result, but only if we're in the Networking state.
		// This stops conflicts of trying to move between states incorrectly, i.e. moving in the wrong sequence.
		guard let testMasterResult = self.testMasterResult where self.stateMachine.isInState(ManagerState.Networking) else {
			print("There's either no testMasterResult or we're not in the Networking state anymore! No actions taken, nothing saved.")
			return
		}
		
		// Add the result to the Test Master's array.
		testMasterResult.networkResults.append(result)
		
		// Update the progress delegate to update the UI.
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count {
				
				let progress = Double((abs(remainingTests - self.originalTestCount) * 4) + 2) / self.progressTarget
				
				progressDelegate.progressReport(progress)
		}
		
		// Fire the event to call the next test state, pinging in this case.
		stateMachine.fireEvent(ManagerEvents.Ping)
	}
	
	func didFinishPing(sender: PingTester, result: PingResult) {
		print("Finished ping test!")
		
		// Get the Test Master result object, but only if we're in the ping test state.
		// This stops conflicts of trying to move between states incorrectly, i.e. moving in the wrong sequence.
		guard let testMasterResult = self.testMasterResult where self.stateMachine.isInState(ManagerState.Pinging) else {
			print("There's either no testMasterResult or we're not in the Pinging state anymore! No actions taken, nothing saved.")
			return
		}
		
		// Add the ping result to the Test Master's array.
		testMasterResult.pingResults.append(result)
		
		// Update the progress delegate to update the UI.
		if let progressDelegate = self.progressDelegate,
			let remainingTests = self.testPlan?.count {
				
				let progress = Double((abs(remainingTests - self.originalTestCount) * 4) + 3) / self.progressTarget
				
				progressDelegate.progressReport(progress)
		}
		
		// If there are endpoint tests left in the array go back into the test loop again, otherwise break out to the post-test state.
		if let remainingTests = self.testPlan where !remainingTests.isEmpty {
			print("Still endpoint tests yet to be run!")
			stateMachine.fireEvent(ManagerEvents.Endpoint)
		} else {
			print("Finished all endpoints, heading to PostTestState!")
			stateMachine.fireEvent(ManagerEvents.Finish)
		}
	}
	
	// MARK: Helper Methods
	
	// A helper function to determine whether the device has any internet connectivity.
	// Derived from the open source Reachability library.
	private func hasConnectivity() -> Bool {
		do {
			let reachability: Reachability =  try Reachability.reachabilityForInternetConnection()
			let networkStatus: String = reachability.currentReachabilityStatus.description
			return networkStatus != "No Connection"
		} catch {
			return false
		}
	}
	
	// A helper function to determine device type.
	private func platform() -> String {
		var sysinfo = utsname()
		uname(&sysinfo) // ignore return value
		return NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: NSASCIIStringEncoding)! as String
	}

}
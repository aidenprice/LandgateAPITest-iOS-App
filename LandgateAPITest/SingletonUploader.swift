//
//  SingletonUploader.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 31/01/2016.
//  Copyright © 2016 Endeavour Apps. All rights reserved.
//

import Foundation
import RealmSwift
import Transporter

// MARK: Constants

struct UploaderEvents {
	static let Start = "StartUpload"
	static let Success = "UploadSucceeded"
	static let Fail = "UploadFailed"
	static let Ready = "ReturnToReadyState"
	static let NewTests = "NewTests"
	static let Abort = "Abort"
}

// MARK: State Enum

enum UploaderState {
	case Ready, Uploading, Success, Fail
}

// MARK: TestUploader Singleton
/**
Test Uploader singleton,
Very similar to the Test Manager singleton, uploads tests to the Google App Engine web service sequentially, 
looping through ready, uploading and success states until its queue is empty.
*/
class TestUploader {
	static let sharedInstance = TestUploader()
	
	let stateMachine: StateMachine<UploaderState>
	
//	var jsonRealm: Realm?
//	var writeRealm: Realm?
	
	var resultKey: String?
	
	var queue = [String]()
	
	init() {
		print("Uploader State Machine started")
		let readyState = State(UploaderState.Ready)
		let uploadingState = State(UploaderState.Uploading)
		let successState = State(UploaderState.Success)
		let failState = State(UploaderState.Fail)
		
		let stateMachine = StateMachine(initialState: readyState, states: [readyState, uploadingState, successState, failState])
		
		let startEvent = Event(name: UploaderEvents.Start, sourceValues: [UploaderState.Ready, UploaderState.Success, UploaderState.Fail], destinationValue: UploaderState.Uploading)
		let successEvent = Event(name: UploaderEvents.Success, sourceValues: [UploaderState.Uploading], destinationValue: UploaderState.Success)
		let failEvent = Event(name: UploaderEvents.Fail, sourceValues: [UploaderState.Uploading], destinationValue: UploaderState.Fail)
		let backToReadyEvent = Event(name: UploaderEvents.Ready, sourceValues: [UploaderState.Success, UploaderState.Fail], destinationValue: UploaderState.Ready)
		let newTestsEvent = Event(name: UploaderEvents.NewTests, sourceValues: [UploaderState.Ready], destinationValue: UploaderState.Ready)
		let abortEvent = Event(name: UploaderEvents.Abort, sourceValues: [UploaderState.Uploading], destinationValue: UploaderState.Fail)
		
		stateMachine.addEvents([startEvent, successEvent, failEvent, backToReadyEvent, newTestsEvent, abortEvent])
		
		self.stateMachine = stateMachine
		
		readyState.didEnterState = { _ in self.didEnterReadyState() }
		uploadingState.didEnterState = { _ in self.didEnterUploadingState() }
		successState.didEnterState = { _ in self.didEnterSuccessState() }
		failState.didEnterState = { _ in self.didEnterFailState() }
	}
	
	// MARK: Public API
	
	// Other objects can, and do, fire events at the state machine to cause it to change its behaviour.
	func uploadTests(tests: [String]) {
		self.queue += tests
		
		if !self.queue.isEmpty {
			stateMachine.fireEvent(UploaderEvents.Start)
		}
	}
	
	// MARK: Statemachine Event Functions
	
	func didEnterReadyState() {
		print("Entered Ready state")
		
		if !self.queue.isEmpty {
			stateMachine.fireEvent(UploaderEvents.Start)
		}
	}
	
	func didEnterUploadingState() {
		print("Entered Uploading state")
		
		guard !self.queue.isEmpty && hasConnectivity() else {
			print("Can't upload! Either no tests in queue or no connectivity.")
			stateMachine.fireEvent(UploaderEvents.Fail)
			return
		}
		
		// Grab the object's primary key so we can reinstantiate it on the background uploading thread.
		print("About to grab the next TestMaster in the queue.")
		self.resultKey = self.queue.removeLast()
		
		// Grab a new pointer to the Realm on this thread
		var jsonRealm: Realm? = nil
		do {
			try jsonRealm = Realm()
		} catch {
			print("Error getting jsonRealm.")
			stateMachine.fireEvent(UploaderEvents.Fail)
		}
		
		guard let result = jsonRealm?.objectForPrimaryKey(TestMasterResult.self, key: resultKey!) else {
			print("Error getting jsonRealm or objectForPrimaryKey.")
			stateMachine.fireEvent(UploaderEvents.Fail)
			return
		}
		
		let resultDict: [String:AnyObject] = ["campaignName":"production_campaign", "TestMasters":[result.toDict()]]
		
		guard let jsonData = try? NSJSONSerialization.dataWithJSONObject(resultDict, options: []) else {
			print("Couldn't encode JSON for upload.")
			stateMachine.fireEvent(UploaderEvents.Fail)
			return
		}
		
		// NSURLSession config and parameters
		let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
		
		guard let url = NSURL(string: "https://landgateapitest.appspot.com/database") else {
			print("Can't produce NSURL from string, odd that this would happen, frankly.")
			stateMachine.fireEvent(UploaderEvents.Fail)
			return
		}
		
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = HTTPMethod.post.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Start the upload task.
		let task = session.uploadTaskWithRequest(request, fromData: jsonData) { data, response, error in
			let statusCode = (response as! NSHTTPURLResponse).statusCode
			print("Response code; \(statusCode)")
			print("Response; \(response)")
			
			if error != nil {
				print("Upload task failed!")
				print("Error: \(error!.localizedDescription)")
				
				self.stateMachine.fireEvent(UploaderEvents.Fail)
				
			} else if statusCode >= 400 {
				// The 555 error code is a custom response code I built into the Google App Engine web app.
				// It's meant to help determine custom exception types from generic internet errors.
				// Unfortunately it doesn't come with an error payload and needs to be handled separately.
				print("Upload task failed!")
				let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
				print("Response; \(datastring)")
				
				self.stateMachine.fireEvent(UploaderEvents.Fail)
				
			} else {
				
				print("Upload task successful!")
				let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
				print("Response; \(datastring)")
				
				self.stateMachine.fireEvent(UploaderEvents.Success)
			}
		}
		task.resume()
	}
	
	func didEnterSuccessState() {
		print("Entered Success State.")
		
		// Assume that iOS has pushed the upload task to a background thread, as Realm objects are not thread safe
		// we have to get a new Realm and a new instance of the ResultObject, thankfully we stored the primary key earlier.
		
		let backgroundQueue = dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
		dispatch_async(backgroundQueue, {
			print("About to get a pointer to Realm.")
			
			var writeRealm: Realm? = nil
			do {
				try writeRealm = Realm()
				
				guard let resultOnAnotherThread = writeRealm?.objectForPrimaryKey(TestMasterResult.self, key: self.resultKey!) else {
					print("Error getting objectForPrimaryKey.")
					return
				}
				try writeRealm!.write { resultOnAnotherThread.uploaded = true }
								
				print("Changed uploaded flag to \(resultOnAnotherThread.uploaded)")
				
			} catch {
				print("Can't change uploaded flag in Realm!")
			}
		})
		
		if !self.queue.isEmpty {
			print("Still uploads in the queue.")
			stateMachine.fireEvent(UploaderEvents.Start)
		} else {
			print("Queue emptied! Back to ready state instead!")
			stateMachine.fireEvent(UploaderEvents.Ready)
		}
	}
	
	func didEnterFailState() {
		print("Entered fail state.")
		
		// TODO add a pop up to alert the user.
		
		if !self.queue.isEmpty {
			print("Still uploads in the queue.")
			stateMachine.fireEvent(UploaderEvents.Start)
		} else {
			print("Queue emptied! Back to ready state instead!")
			stateMachine.fireEvent(UploaderEvents.Ready)
		}

	}
	
	// MARK: Helper methods
	
	/**
		Checks whether the device can connect to the internet.
		Intended to prevent upload attempts when there is no connectivity.
		Uses the open source reachability library.
	*/
	private func hasConnectivity() -> Bool {
		do {
			let reachability: Reachability =  try Reachability.reachabilityForInternetConnection()
			let networkStatus: String = reachability.currentReachabilityStatus.description
			return networkStatus != "No Connection"
		} catch {
			return false
		}
	}
}
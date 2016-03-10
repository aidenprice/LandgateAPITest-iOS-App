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
	
	let realm: Realm
	
	var queue = [TestMasterResult]()
	
	init() {
		print("Uploader State Machine started")
		let readyState = State(UploaderState.Ready)
		let uploadingState = State(UploaderState.Uploading)
		let successState = State(UploaderState.Success)
		let failState = State(UploaderState.Fail)
		
		let stateMachine = StateMachine(initialState: readyState, states: [readyState, uploadingState, successState, failState])
		
		let startEvent = Event(name: UploaderEvents.Start, sourceStates: [UploaderState.Ready, UploaderState.Success], destinationState: UploaderState.Uploading)
		let successEvent = Event(name: UploaderEvents.Success, sourceStates: [UploaderState.Uploading], destinationState: UploaderState.Success)
		let failEvent = Event(name: UploaderEvents.Fail, sourceStates: [UploaderState.Uploading], destinationState: UploaderState.Fail)
		let backToReadyEvent = Event(name: UploaderEvents.Ready, sourceStates: [UploaderState.Success, UploaderState.Fail], destinationState: UploaderState.Ready)
		let newTestsEvent = Event(name: UploaderEvents.NewTests, sourceStates: [UploaderState.Ready], destinationState: UploaderState.Ready)
		let abortEvent = Event(name: UploaderEvents.Abort, sourceStates: [UploaderState.Uploading], destinationState: UploaderState.Fail)
		
		stateMachine.addEvents([startEvent, successEvent, failEvent, backToReadyEvent, newTestsEvent, abortEvent])
		
		self.stateMachine = stateMachine

		var uploadRealm: Realm? = nil
		do {
			try uploadRealm = Realm()
		} catch {
			print("SingletonUploader Realm start up failure!")
		}
		self.realm = uploadRealm!
		
		readyState.didEnterState = { _ in self.didEnterReadyState() }
		uploadingState.didEnterState = { _ in self.didEnterUploadingState() }
		successState.didEnterState = { _ in self.didEnterSuccessState() }
		failState.didEnterState = { _ in self.didEnterFailState() }
		
	}
	
	// MARK: Public API
	
	// Other objects can, and do, fire events at the state machine to cause it to change its behaviour.
	func uploadTests(tests: [TestMasterResult]) {
		self.queue += tests
		
		if !self.queue.isEmpty {
			stateMachine.fireEvent(UploaderEvents.Start)
		}
	}
	
	// MARK: Statemachine Event Functions
	
	private func didEnterReadyState() {
		print("Entered Ready state")
		
		if !self.queue.isEmpty {
			stateMachine.fireEvent(UploaderEvents.Start)
		}
	}
	
	private func didEnterUploadingState() {
		print("Entered Uploading state")
		
		guard !self.queue.isEmpty && hasConnectivity() else {
			print("Can't upload! Either no tests in queue or no connectivity.")
			stateMachine.fireEvent(UploaderEvents.Fail)
			return
		}
		
		// Grab the object and its primary key so we can reinstantiate it on the background uploading thread.
		let result = self.queue.removeLast()
		let resultKey = result.testID
		
		guard let jsonData = try? NSJSONSerialization.dataWithJSONObject(result.toDict(), options: []) else {
			print("Couldn't encode JSON for upload.")
			stateMachine.fireEvent(UploaderEvents.Fail)
			return
		}
		
		// NSURLSession config and parameters
		let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
		
		guard let url = NSURL(string: "https://landgateapitest.appspot.com/database") else { return }
		
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = HTTPMethod.post.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Start the upload task.
		let task = session.uploadTaskWithRequest(request, fromData: jsonData) { data, response, error in
			print("Upload task started!")
			if error == nil {
				print("Upload task successful!")
				print("Response; \(response)")
				
				// Assume that iOS has pushed the upload task to a background thread, as Realm objects are not thread safe
				// we have to get a new Realm and a new instance of the ResultObject, thankfully we stored the primary key earlier.
				do {
					let writeRealm = try Realm()
					if let resultOnAnotherThread = writeRealm.objectForPrimaryKey(ResultObject.self, key: resultKey) {
						try writeRealm.write { resultOnAnotherThread.uploaded = true }
					}
				} catch {
					print("Can't change uploaded flag in Realm!")
				}
				
				self.stateMachine.fireEvent(UploaderEvents.Success)
				
			} else {
				print("Upload task failed!")
				let statusCode = (response as! NSHTTPURLResponse).statusCode
				print("Response code; \(statusCode)")
				print("Response; \(response)")
				print("Error: \(error!.localizedDescription)")
				self.stateMachine.fireEvent(UploaderEvents.Fail)
			}
		}
		task.resume()
	}
	
	private func didEnterSuccessState() {
		print("Entered Success State.")
		
		if !self.queue.isEmpty {
			print("Still uploads in the queue.")
			stateMachine.fireEvent(UploaderEvents.Start)
		} else {
			print("Queue emptied! Back to ready state instead!")
			stateMachine.fireEvent(UploaderEvents.Ready)
		}
	}
	
	private func didEnterFailState() {
		print("Entered fail state.")
		
		// TODO add a pop up to alert the user.
	}
	
	// MARK: Helper methods
	
	/**
		Checks whether the device can connect to the internet.
		Intended to prevent upload attempts when there is not connectivity.
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
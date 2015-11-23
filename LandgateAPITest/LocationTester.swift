//
//  LocationTester.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 16/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationTesterDelegate: class {
	func didFinishLocating(sender: LocationTester, result: LocationResult)
}

class LocationTester: NSObject, CLLocationManagerDelegate {
	static let sharedInstance = LocationTester()
	
	weak var delegate: LocationTesterDelegate?
	
	let locationManager: CLLocationManager = CLLocationManager()
	
	var locationResult: LocationResult?
	
	func locate(delegateObject: TestManager, id: idDetails) throws {
		self.delegate = delegateObject
		self.locationResult = LocationResult()
		
		guard let _ = self.delegate, locationResult = self.locationResult else {
			print("Locate method failed. Missing either a delegateObject or a LocationResult")
			throw SubTestError.missingResultObject(reason: "Locate method failed. Missing either a delegateObject or a LocationResult")
		}
		
		locationResult.datetime = NSDate().timeIntervalSince1970
		locationResult.testID = "\(id.deviceID)" + "\(locationResult.datetime)"
		locationResult.parentID = id.parentID
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.requestWhenInUseAuthorization()		
		locationManager.requestLocation()
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let delegate = self.delegate, locationResult = self.locationResult else {
			fatalError("LocationManager didUpdateLocations delegate method failed. Missing either a delegateObject or a LocationResult")
		}
		
		guard let location = locations.first else {
			print("Failed to locate device.")
			locationResult.comment = "Failed to locate device."
			delegate.didFinishLocating(self, result: locationResult)
			return
		}
		
		print("Location successful! Current location: \(location)")
		locationResult.latitude.value = location.coordinate.latitude
		locationResult.longitude.value = location.coordinate.longitude
		locationResult.datetime = location.timestamp.timeIntervalSince1970
		locationResult.success = true
		
		delegate.didFinishLocating(self, result: locationResult)
	}
}

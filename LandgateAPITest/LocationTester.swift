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

class LocationTester: CLLocationManagerDelegate {
	static let sharedInstance = LocationTester()
	
	weak var delegate: LocationTesterDelegate?
	weak var parent: TestManager?
	
	let locationManager: CLLocationManager = CLLocationManager()
	
	var locationResult: LocationResult?
	
	func locate(delegateObject: TestManager) {
		self.delegate = delegateObject
		self.parent = delegateObject
		
		self.locationResult = LocationResult()
		self.locationResult?.datetime = NSDate().timeIntervalSince1970
		self.locationResult?.testID = "\(self.parent?.testMasterResult?.deviceID)" + "\(self.locationResult?.datetime)"
		self.locationResult?.parentID = self.parent?.testMasterResult?.testID
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.requestWhenInUseAuthorization()		
		locationManager.requestLocation()
		
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			print("Current location: \(location)")
			self.locationResult?.latitude.value = location.coordinate.latitude
			self.locationResult?.longitude.value = location.coordinate.longitude
			self.locationResult?.datetime = location.timestamp.timeIntervalSince1970
			self.locationResult?.success = true
			
		} else {
			print("Failed to locate device.")
			self.locationResult?.comment = "Failed to locate device."
		}
		
		self.delegate?.didFinishLocating(self, result: self.locationResult!)
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Error while updating location " + error.localizedDescription)
		self.locationResult?.comment = error.localizedDescription
		
		self.delegate?.didFinishLocating(self, result: self.locationResult!)

	}
	
	
}

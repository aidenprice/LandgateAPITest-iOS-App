//
//  OldTestViewController.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 10/12/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import UIKit
import MapKit

import RealmSwift

class OldTestViewController: UIViewController {
	
	var parentTestMasterResult: TestMasterResult?
	
	var locationResults: Results<LocationResult>?
	var pingResults: Results<PingResult>?
	var networkResults: Results<NetworkResult>?
	var endpointResults: Results<EndpointResult>?
	
	var successRatio: Double {
		guard let endpoints = self.endpointResults where !endpoints.isEmpty else { return 0.0 }
		
		let failures = endpoints.filter("success == false")
		
		return Double(endpoints.count - failures.count) / Double (endpoints.count)
	}
	
	var averageResponseTime: Double {
		guard let endpoints = self.endpointResults where !endpoints.isEmpty else { return 0.0 }
		
		var total = 0.0
		
		for endpoint in endpoints {
			total += (endpoint.finishDatetime - endpoint.startDatetime)
		}
		
		return total / Double(endpoints.count)
	}

	@IBOutlet weak var dateTimeLabel: UILabel!
	@IBOutlet weak var successRatioLabel: UILabel!
	@IBOutlet weak var averageResponseTimeLabel: UILabel!
	
	@IBOutlet weak var map: MKMapView!
	
	@IBOutlet weak var tableview: UITableView!
	
	let dateFormatter = NSDateFormatter()
	let numberFormatter = NSNumberFormatter()
	
	lazy var realm: Realm = {
		print("Realm started! Check for multiple startups!")
		var testRealm: Realm
		do {
			try testRealm = Realm()
			print("Using default Realm")
			
		} catch {
			
			var realmFailAlert = UIAlertController(title: "Data storage error!", message: "The app is unable to save your test data to disk. We'll save data in memory to allow you to upload it but it will not persist between app launches. Thank you!", preferredStyle: UIAlertControllerStyle.Alert)
			
			realmFailAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
				print("OK Selected, lets get on with it.")
				
			}))
			self.presentViewController(realmFailAlert, animated: true, completion: nil)
			
			try! testRealm = Realm(configuration: Realm.Configuration(inMemoryIdentifier: "InMemoryRealm"))
			print("Using In Memory Realm")
		}
		print(testRealm)
		return testRealm
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		guard let testMasterResult = self.parentTestMasterResult else {
			self.dateTimeLabel.text = "No Test Found!"
			self.successRatioLabel.text = ""
			self.averageResponseTimeLabel.text = ""
			
			return
		}
		
		let date = NSDate(timeIntervalSince1970: testMasterResult.datetime)
		
		dateFormatter.dateFormat = "H:mm dd/MM/yyyy"
		
		dateTimeLabel.text = "\(dateFormatter.stringFromDate(date))"
		
		locationResults = realm.objects(LocationResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		pingResults = realm.objects(PingResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		networkResults = realm.objects(NetworkResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		endpointResults = realm.objects(EndpointResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		
		numberFormatter.maximumFractionDigits = 2
		numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
		
		successRatioLabel.text = "Successful tests: \(numberFormatter.stringFromNumber(successRatio * 100))%"
		
		averageResponseTimeLabel.text = "Average response time: \(numberFormatter.stringFromNumber(averageResponseTime)) seconds"
		
		setUpMap()
		
		
		

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setUpMap() {
		guard let locations = self.locationResults where !locations.isEmpty else {
			let location = CLLocationCoordinate2D(latitude: -23.11666667, longitude: 132.133333)
			let span = MKCoordinateSpanMake(15, 25)
			let region = MKCoordinateRegion(center: location, span: span)
			map.setRegion(region, animated: false)
			
			return
		}
		
		var minX: Double?
		var minY: Double?
		var maxX: Double?
		var maxY: Double?
		
		var annotationsArray = [MKPointAnnotation]()
		
		if let locations = locationResults where !locations.isEmpty {
			for location in locations {
				if let
				let point = CLLocationCoordinate2DMake(location.latitude, location.longitude)
				let annotation = MKPointAnnotation()
				annotation.coordinate = point
				annotationsArray.append(annotation)
			}
		}
		
		
		let location = CLLocationCoordinate2D(latitude: -23.11666667, longitude: 132.133333)
		let distance = 1000
		let region = MKCoordinateRegionMakeWithDistance(center: location, distance: distance)
		map.setRegion(region, animated: true)
		
	}
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

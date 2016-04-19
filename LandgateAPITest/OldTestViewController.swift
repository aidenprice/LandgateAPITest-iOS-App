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

struct OldEndpointConstants {
	static let oldEndpointCellReuse = "OldEndpointTableViewCell"
}

class OldEndpointTableViewCell: UITableViewCell {
	
	@IBOutlet weak var dateTimeLabel: UILabel!
	@IBOutlet weak var successLabel: UILabel!
	
	@IBOutlet weak var responseTimeLabel: UILabel!
	@IBOutlet weak var responseSizeLabel: UILabel!
	
}

class OldTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var dateTimeLabel: UILabel!
	@IBOutlet weak var successRatioLabel: UILabel!
	@IBOutlet weak var averageResponseTimeLabel: UILabel!
	
	@IBOutlet weak var map: MKMapView!
	
	@IBOutlet weak var tableView: UITableView!
	
	let dateFormatter = NSDateFormatter()
	let timeFormatter = NSDateFormatter()
	let numberFormatter = NSNumberFormatter()
	
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
	
	// MARK: - View Controller Functions
	
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .Plain, target: self, action: #selector(OldTestViewController.uploadTest))
		
		tableView.dataSource = self
		tableView.delegate = self
		
		self.dateTimeLabel.text = "No Test Found!"
		self.successRatioLabel.text = ""
		self.averageResponseTimeLabel.text = ""
		
		guard let testMasterResult = self.parentTestMasterResult else { return }
		
//		guard let testMasterResult = realm.objectForPrimaryKey(EndpointResult.self, key: masterKey) else { return }
		
		let date = NSDate(timeIntervalSince1970: testMasterResult.datetime)
		
		dateTimeLabel.text = "\(dateFormatter.stringFromDate(date))"
		
		locationResults = realm.objects(LocationResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		pingResults = realm.objects(PingResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		networkResults = realm.objects(NetworkResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		endpointResults = realm.objects(EndpointResult).filter("parentID = %@", testMasterResult.testID).sorted("datetime", ascending: true)
		
		dateFormatter.dateFormat = "h:mm a EEEE d MMMM yyyy"
		timeFormatter.dateFormat = "h:mm:ss a"
		
		numberFormatter.maximumFractionDigits = 3
		numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
		
		successRatioLabel.text = "Successful tests: \(numberFormatter.stringFromNumber(successRatio * 100)!)%"
		
		averageResponseTimeLabel.text = "Average response time: \(numberFormatter.stringFromNumber(averageResponseTime)!) seconds"
		
		setUpMap()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		// invalidate() causes the Realm DB to drop references to query results
		// returning them to the store unchanged. Used here to free up memory.
//		realm.invalidate()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard let tests = endpointResults else {
			return 0
		}
		
		return tests.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(OldEndpointConstants.oldEndpointCellReuse, forIndexPath: indexPath) as! OldEndpointTableViewCell
		
		guard let test = endpointResults?[indexPath.row] else {
			cell.dateTimeLabel.text = "No test found"
			cell.successLabel.text = ""
			cell.responseTimeLabel.text = ""
			cell.responseSizeLabel.text = ""

			return cell
		}
		
		cell.dateTimeLabel.text = "\(timeFormatter.stringFromDate(NSDate(timeIntervalSince1970: test.datetime)))"
		
		if test.success == true {
			cell.successLabel.text = "Succeeded"
		} else if test.responseCode == 0 {
			cell.successLabel.text = "Failed No Response"
		} else {
			cell.successLabel.text = "Failed Response Code: \(test.responseCode)"
		}
		
		cell.responseTimeLabel.text = "Time: \(numberFormatter.stringFromNumber(test.finishDatetime - test.startDatetime)!) sec"
		
		if let data = test.responseData {
			cell.responseSizeLabel.text = "Size: \(data.length / 1000)kB"
		} else {
			cell.responseSizeLabel.text = "Size: Nil"
		}
		
		return cell
	}

	// MARK: Private API
	
	private func setUpMap() {
		
		var minX = 112.467
		var minY = -55.050
		var maxX = 154.200
		var maxY = -9.133
		
		if let locations = locationResults where !locations.isEmpty {
			
			var allXValues = [Double]()
			var allYValues = [Double]()
			
			for location in locations {
				
				allXValues.append(location.longitude)
				allYValues.append(location.latitude)
				
				let point = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
				let annotation = MKPointAnnotation()
				annotation.coordinate = point
				map.addAnnotation(annotation)
			}
			minX = allXValues.minElement()! - 0.1
			minY = allYValues.minElement()! - 0.1
			maxX = allXValues.maxElement()! + 0.1
			maxY = allYValues.maxElement()! + 0.1
		}
		
		let spanX = abs(maxX - minX)
		let spanY = abs(maxY - minY)
		
		let centreX = (maxX + minX) / 2.0
		let centreY = (maxY + minY) / 2.0
		
		let newLocation = CLLocationCoordinate2D(latitude: centreY, longitude: centreX)
		let newSpan = MKCoordinateSpanMake(spanY, spanX)
		let newRegion = MKCoordinateRegion(center: newLocation, span: newSpan)
		map.setRegion(newRegion, animated: true)
	}
	
	func uploadTest() {
		TestUploader.sharedInstance.uploadTests([self.parentTestMasterResult!.testID])
	}
}

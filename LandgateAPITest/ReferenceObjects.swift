//
//  ReferenceObjects.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 10/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation

// Holds the "correct" responses to each request.
// A test result object will call for the matching reference object to compare the response received.
// Differences between the two will be highlighted for future analysis.

struct Reference {
	let test: Template
	let validDate: NSDate
	let response: String
}
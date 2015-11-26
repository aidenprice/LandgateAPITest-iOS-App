//
//  TestingTips.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 9/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation

struct Tips {
	static let tipDict: [Int: String] = [
		1: "Please don't test from home.\nThis is important for the sake of" +
		"your privacy. This data may enter the public domain.\n" +
		"At the same time, a slew of tests using your home " +
		"wifi connection will not be very illuminating.\n" +
		"Go out to a cafe and run a test on their shaky wifi instead!",

		2:"Remeber touching your phone while driving is illegal.\n" +
		"Ask a passenger to run tests for you instead.\n" +
		"Better yet, take a bus and run a number of tests as you move around",

		3:"The app will not conduct tests or ping your location when in " +
		"the background. This is by design for the sake of your battery and " +
		"your privacy.\nIf you switch to another app or receive a phone call " +
		"the current test will terminate and save what results it has to the " +
		"internal database. It will not automatically upload the results either.",

		4:"Please do not exceed your data cap and run up a huge phone bill for " +
		"the sake of this research.\nMost tests are designed to minimise " +
		"total downloads, except for the WiFi test. The WiFi test deliberately " +
		"asks for larger downloads and more of them. Avoid running this test " +
		"when on a 3G or 4G connection.\nIf you want to go over your download cap " +
		"to help with this research approach me at aiden.price@postgrad.curtin.edu.au " +
		"and I'll see what I can do to help you financially.\nKeep in mind that " +
		"the budget for this research is $0.",

		5:"The test will not start if you do not have a connection to the internet.\n" +
		"That much is straight-forward. The interesting part of this research is " +
		"what happens when you move in and out of reception while testing.\n" +
		"Fluctuation in signal strength that may make a request time out is " +
		"another example of an ideal situation to test.",

		6:"Each test records your mobile carrier, cell tower id and signal strength.\n" +
		"If this sounds like too much information then please just conduct tests on wifi.",

		7:"Don't waste time and download limit on running twenty tests in the exact same " +
		"situation. Getting the same result over and over without changing signal strength " +
		"or cell tower (or some other variable) will just skew the final results.\n" +
		"Move around, turn your wifi off, stand on your head and do the mobile reception " +
		"dance. Anything to test the API requests in different places and cases.",

		8:"Please stay safe while testing.\nWe don't need to know the signal strength " +
		"at the edge of a cliff. We don't want drivers to take their eyes off the road. " +
		"There's no point taking any risk for the sake of this research.",

		9:"Remember that uploading test results will use just as much data as " +
		"downloading them in the first place. You can always upload at a later date " +
		"on a wifi connection.",

		10:"Landgate are in no way affliated with this research project.\n" +
		"They are in no way responsible for the design, functionality or code " +
		"in this app.\nNeither are they required to provide support to users of this app. " +
		"Please contact aiden.price@postgrad.curtin.edu.au for all support requests.\n" +
		"They have been very encouraging and most willing to help. Thank you to the Landgate team."
	]
}
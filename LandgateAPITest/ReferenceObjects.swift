//
//  ReferenceObjects.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 25/04/2016.
//  Copyright © 2016 Endeavour Apps. All rights reserved.
//

import Foundation

struct ReferenceFile {
	let name: String
	let fileName: String
	var reference: String?
}

struct ReferenceFiles {
	static var files: [ReferenceFile] = [
		ReferenceFile(name: "Big", fileName: "GME_AerialPhoto_Big_GET_Image", reference: nil),
		ReferenceFile(name: "GetTileKVP", fileName: "GME_AerialPhoto_GetTileKVP_GET_Image", reference: nil),
		ReferenceFile(name: "GetTileKVP2", fileName: "GME_AerialPhoto_GetTileKVP2_GET_Image", reference: nil),
		ReferenceFile(name: "GetTileKVP3", fileName: "GME_AerialPhoto_GetTileKVP3_GET_Image", reference: nil),
		ReferenceFile(name: "GetTileKVP4", fileName: "GME_AerialPhoto_GetTileKVP4_GET_Image", reference: nil),
		ReferenceFile(name: "Small", fileName: "GME_AerialPhoto_Small_GET_Image", reference: nil),
		ReferenceFile(name: "WMSGetCapabilities", fileName: "GME_AerialPhoto_WMSGetCapabilities_GET_XML", reference: nil),
		ReferenceFile(name: "WMTSGetCapabilities", fileName: "GME_AerialPhoto_WMTSGetCapabilities_GET_XML", reference: nil),
		ReferenceFile(name: "AttributeFilter", fileName: "GME_BusStops_AttributeFilter_GET_JSON", reference: nil),
		ReferenceFile(name: "Big", fileName: "GME_BusStops_Big_GET_JSON", reference: nil),
		ReferenceFile(name: "DistanceFilter", fileName: "GME_BusStops_DistanceFilter_GET_JSON", reference: nil),
		ReferenceFile(name: "FeatureByID", fileName: "GME_BusStops_FeatureByID_GET_JSON", reference: nil),
		ReferenceFile(name: "IntersectFilter", fileName: "GME_BusStops_IntersectFilter_GET_JSON", reference: nil),
		ReferenceFile(name: "Small", fileName: "GME_BusStops_Small_GET_JSON", reference: nil)
	]
}

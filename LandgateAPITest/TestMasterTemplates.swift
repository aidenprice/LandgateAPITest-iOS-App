//
//  TestMasterTemplates.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 5/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case head = "HEAD"
}

// MARK: - TestEndpoint Templates

struct TETemplate {
	let url: String
	let method: HTTPMethod
	let body: String?
}

struct TestEndpoint {
	static let GME_GET_BusStops_Small = TETemplate(
		url: "https://www.googleapis.com/mapsengine/v1/tables/09372590152434720789-08620406515972909896/features?version=published&maxResults=25&select=STOPID%2CSTOPNAME%2CSTOPTYPE%2Cgeometry&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_BusStops_Big = TETemplate(
		url: "https://www.googleapis.com/mapsengine/v1/tables/09372590152434720789-08620406515972909896/features?version=published&maxResults=500&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_BusStops_FeatureByID = TETemplate(
		url: "https://www.googleapis.com/mapsengine/v1/tables/09372590152434720789-08620406515972909896/features/1847?version=published&maxResults=25&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_BusStops_AttributeFilter = TETemplate(
		url: "https://www.googleapis.com/mapsengine/v1/tables/09372590152434720789-08620406515972909896/features?version=published&where=LOCATION%20CONTAINS%20%27Curtin%27%20AND%20SUBURB%20CONTAINS%20%27BENTLEY%27%20AND%20STATUS%20CONTAINS%20%27Active%27&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_BusStops_DistanceFilter = TETemplate(
		url: "https://www.googleapis.com/mapsengine/v1/tables/09372590152434720789-08620406515972909896/features?version=published&select=STOPID%2CSTOPNAME%2CSTOPTYPE%2CSTATUS%2CLOCATION%2CSUBURB%2Cgeometry%2CST_Distance%28geometry%2CST_POINT%28115.895095%2C-32.007143%29%29%20as%20distance&orderBy=distance&limit=1&where=STATUS%20CONTAINS%20%27Active%27&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_BusStops_IntersectFilter = TETemplate(
		url: "https://www.googleapis.com/mapsengine/v1/tables/09372590152434720789-08620406515972909896/features?version=published&select=STOPID%2CSTOPNAME%2CSTOPTYPE%2CSTATUS%2CLOCATION%2CSUBURB%2Cgeometry&orderBy=STOPNAME&where=STATUS%20CONTAINS%20%27Active%27&intersects=POLYGON%28%28115.8861773031899%20-31.99754322345886%2C%20115.8880417106566%20-32.00575228301201%2C%20115.8860718954193%20-32.01293450013328%2C%20115.894379415096%20-32.01350664629256%2C%20115.8939605952021%20-32.0119340941473%2C%20115.8934324720389%20-32.01154462279226%2C%20115.8937844220442%20-32.01021176821627%2C%20115.897005592728%20-32.0078328487639%2C%20115.8998850276332%20-32.00893175550439%2C%20115.9009673001542%20-32.00825477399166%2C%20115.8971881688856%20-32.00516242141832%2C%20115.8963344811994%20-32.0038082005204%2C%20115.8954071313707%20-32.0013269008619%2C%20115.8934248136717%20-31.99897245405646%2C%20115.890330338636%20-31.99790449476763%2C%20115.8861773031899%20-31.99754322345886%29%29&limit=75&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMS_GetCapabilities = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wms/?service=wms&version=1.3.0&request=GetCapabilities&exceptions=XML&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMS_GetMap_Small = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wms/?service=wms&version=1.1.1&request=GetMap&srs=EPSG%3A4326&format=image%2Fpng&height=50&width=50&bbox=115.894855%2C-32.007438%2C115.895456%2C-32.006877&layers=09372590152434720789-02344374277596842979-4&styles=&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMS_GetMap_Big = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wms/?service=wms&version=1.1.1&request=GetMap&srs=EPSG%3A4326&format=image%2Fpng&height=500&width=500&bbox=115.894855%2C-32.007438%2C115.895456%2C-32.006877&layers=09372590152434720789-02344374277596842979-4&styles=&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMTS_GetCapabilities = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wmts/?service=wmts&version=1.0.0&request=GetCapabilities&exceptions=XML&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMTS_GetTile1 = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wmts/?service=wmts&version=1.0.0&request=GetTile&exceptions=XML&layer=09372590152434720789-02344374277596842979-4&style=default&format=image%2Fpng&tilematrixset=EPSG%3A900913&tilematrix=EPSG%3A900913%3A19&tilerow=311390&tilecol=430928&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMTS_GetTile2 = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wmts/?service=wmts&version=1.0.0&request=GetTile&exceptions=XML&layer=09372590152434720789-02344374277596842979-4&style=default&format=image%2Fpng&tilematrixset=EPSG%3A900913&tilematrix=EPSG%3A900913%3A19&tilerow=311389&tilecol=430929&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMTS_GetTile3 = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wmts/?service=wmts&version=1.0.0&request=GetTile&exceptions=XML&layer=09372590152434720789-02344374277596842979-4&style=default&format=image%2Fpng&tilematrixset=EPSG%3A900913&tilematrix=EPSG%3A900913%3A19&tilerow=311388&tilecol=430930&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
	static let GME_GET_WMTS_GetTile4 = TETemplate(
		url: "https://mapsengine.google.com/09372590152434720789-03311849775732631692-4/wmts/?service=wmts&version=1.0.0&request=GetTile&exceptions=XML&layer=09372590152434720789-02344374277596842979-4&style=default&format=image%2Fpng&tilematrixset=EPSG%3A900913&tilematrix=EPSG%3A900913%3A19&tilerow=311388&tilecol=430931&key=AIzaSyA9PTBAlQB-GnqQHw2JIPB47D52PdHvZZs",
		method: .get,
		body: nil
	)
}

// MARK: - TestMaster Templates

struct TMTemplate {
	let name: String
	let details: String
	let image: UIImage
	let downloadSize: Int
	let testPlan: [TETemplate]
}

struct TestMaster {
	static let Templates: [TMTemplate] = [
		TMTemplate(
			name: "Standard Test",
			details: "The basic test format and a good all-rounder. " +
					"Tests a variety of endpoints; GeoJSON, WMS, WMTS. " +
					"Asks for small responses for the most part to minimise " +
					"data downloads. One in 10 requests is much larger as a " +
					"control on network latency on response time.",
			image: UIImage(named: "Standard Icon")!,
			downloadSize: 2100,
			testPlan: [
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetCapabilities,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetCapabilities,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4
			]
		),
		TMTemplate(
			name: "Extra Long Test",
			details: "A repetitious test over a long period asking for small " +
					"JSON responses over and over and over. This is a good one " +
					"for those times when you're planning on moving about a lot, " +
					"say on the train or bus.",
			image: UIImage(named: "Extra Long Icon")!,
			downloadSize: 394,
			testPlan: [
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter
			]
		),
		TMTemplate(
			name: "Remote Area Test",
			details: "A test designed for areas with dodgy signal (some of the " +
					"best places on Earth, frankly). Has longer time out times " +
					"and calls for smaller responses.",
			image: UIImage(named: "Remote Area Icon")!,
			downloadSize: 182,
			testPlan: [
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMTS_GetTile1
			]
		),
		TMTemplate(
			name: "WMS Test",
			details: "This test calls for image responses rather than XML or JSON." +
					"It is designed to look for image flaws that may happen when " +
					"your signal drops out partway through a response.\nImportantly, " +
					"this test can lead to big downloads. Please use it sparingly.",
			image: UIImage(named: "WMS Icon")!,
			downloadSize: 5843,
			testPlan: [
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4
			]
		),
		TMTemplate(
			name: "WiFi Test",
			details: "Please DON'T use this test on a 3G or 4G connection, if you " +
					"value your download cap!\nThis is deliberately designed to be " +
					"a big test, looking for big and small responses to control network " +
					"latency.\nDon't test this on your stable home wifi, find some " +
					"flakey wifi network on campus instead. Or better yet, run this test " +
					"while moving between two wifi access points.",
			image: UIImage(named: "WiFi Icon")!,
			downloadSize: 1,
			testPlan: [
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4,
				TestEndpoint.GME_GET_BusStops_Small,
				TestEndpoint.GME_GET_BusStops_Big,
				TestEndpoint.GME_GET_BusStops_FeatureByID,
				TestEndpoint.GME_GET_BusStops_AttributeFilter,
				TestEndpoint.GME_GET_BusStops_DistanceFilter,
				TestEndpoint.GME_GET_BusStops_IntersectFilter,
				TestEndpoint.GME_GET_WMS_GetMap_Small,
				TestEndpoint.GME_GET_WMS_GetMap_Big,
				TestEndpoint.GME_GET_WMTS_GetTile1,
				TestEndpoint.GME_GET_WMTS_GetTile2,
				TestEndpoint.GME_GET_WMTS_GetTile3,
				TestEndpoint.GME_GET_WMTS_GetTile4
			]
		)
	]
}




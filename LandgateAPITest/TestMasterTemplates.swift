//
//  TestMasterTemplates.swift
//  LandgateAPITest
//
//  Created by Aiden Price on 5/11/2015.
//  Copyright © 2015 Endeavour Apps. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constants

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case head = "HEAD"
}

enum ServerType: String {
	case esri = "Esri"
	case ogc = "OGC"
	case gme = "GME"
}

enum Dataset: String {
	case busStops = "BusStops"
	case topo = "Topo"
	case aerial = "AerialPhoto"
}

enum ReturnType: String {
	case xml = "XML"
	case json = "JSON"
	case image = "Image"
}

enum TestName: String {
	case getCapabilities = "GetCapabilities"
	case small = "Small"
	case big = "Big"
	case featureByID = "FeatureByID"
	case attributeFilter = "AttributeFilter"
	case intersectFilter = "IntersectFilter"
	case distanceFilter = "DistanceFilter"
	case getMap = "GetMap"
	case getTileRest = "GetTileRestful"
	case getTileKVP = "GetTileKVP"
}

// MARK: - TestEndpoint Templates

struct TETemplate {
	let server: ServerType
	let dataset: Dataset
	let returnType: ReturnType
	let testName: TestName
	let url: String
	let method: HTTPMethod
	let header: [String:String]?
	let urlParams: [String:String]?
	let bodyString: String?
	let bodyForm: [String:String]?
}

struct TestEndpoint {
	
	//MARK: Esri REST Requests
	
	static let ESRI_BusStops_GetCapabilities_GET_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .getCapabilities,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1",
		method: .get,
		header: nil,
		urlParams:[
			"f":"json"
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_BusStops_GetCapabilities_POST_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .getCapabilities,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1",
		method: .post,
		header: ["Content-Type": "application/x-www-form-urlencoded"],
		urlParams: [
		"f": "json",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_BusStops_Small_GET_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .small,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .get,
		header: nil,
		urlParams: [
			"where": "status='Active'",
			"text": "",
			"objectIds": "",
			"time": "",
			"geometry": "",
			"geometryType": "esriGeometryEnvelope",
			"inSR": "",
			"spatialRel": "esriSpatialRelIntersects",
			"relationParam": "",
			"outFields": "stopid,status,stopname,stoptype",
			"returnGeometry": "true",
			"returnTrueCurves": "false",
			"maxAllowableOffset": "",
			"geometryPrecision": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
			"returnCountOnly": "false",
			"orderByFields": "",
			"groupByFieldsForStatistics": "",
			"outStatistics": "",
			"returnZ": "false",
			"returnM": "false",
			"gdbVersion": "",
			"returnDistinctValues": "false",
			"resultOffset": "",
			"resultRecordCount": "25",
			"f": "json"
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_BusStops_Small_POST_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .small,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .post,
		header: [
			"Content-Type":"application/x-www-form-urlencoded"
		],
		urlParams: nil,
		bodyString: nil,
		bodyForm: [
			"outStatistics": "",
			"objectIds": "",
			"returnCountOnly": "false",
			"time": "",
			"relationParam": "",
			"maxAllowableOffset": "",
			"groupByFieldsForStatistics": "",
			"f": "json",
			"resultRecordCount": "25",
			"outFields": "stopid,status,stopname,stoptype",
			"geometryType": "esriGeometryEnvelope",
			"geometry": "",
			"spatialRel": "esriSpatialRelIntersects",
			"geometryPrecision": "",
			"returnZ": "false",
			"resultOffset": "",
			"where": "status='Active'",
			"returnGeometry": "true",
			"returnM": "false",
			"text": "",
			"inSR": "",
			"orderByFields": "",
			"returnTrueCurves": "false",
			"returnDistinctValues": "false",
			"gdbVersion": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
		]
	)
	
	static let ESRI_BusStops_Big_GET_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .big,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .get,
		header: nil,
		urlParams: [
			"where": "status='Active'",
			"text": "",
			"objectIds": "",
			"time": "",
			"geometry": "",
			"geometryType": "esriGeometryEnvelope",
			"inSR": "",
			"spatialRel": "esriSpatialRelIntersects",
			"relationParam": "",
			"outFields": "*",
			"returnGeometry": "true",
			"returnTrueCurves": "false",
			"maxAllowableOffset": "",
			"geometryPrecision": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
			"returnCountOnly": "false",
			"orderByFields": "",
			"groupByFieldsForStatistics": "",
			"outStatistics": "",
			"returnZ": "false",
			"returnM": "false",
			"gdbVersion": "",
			"returnDistinctValues": "false",
			"resultOffset": "",
			"resultRecordCount": "500",
			"f": "json",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_BusStops_Big_POST_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .big,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .post,
		header: [
			"Content-Type":"application/x-www-form-urlencoded"
		],
		urlParams: nil,
		bodyString: nil,
		bodyForm: [
			"outStatistics": "",
			"objectIds": "",
			"returnCountOnly": "false",
			"time": "",
			"relationParam": "",
			"maxAllowableOffset": "",
			"groupByFieldsForStatistics": "",
			"f": "json",
			"resultRecordCount": "500",
			"outFields": "*",
			"geometryType": "esriGeometryEnvelope",
			"geometry": "",
			"spatialRel": "esriSpatialRelIntersects",
			"geometryPrecision": "",
			"returnZ": "false",
			"resultOffset": "",
			"where": "status='Active'",
			"returnGeometry": "true",
			"returnM": "false",
			"text": "",
			"inSR": "",
			"orderByFields": "",
			"returnTrueCurves": "false",
			"returnDistinctValues": "false",
			"gdbVersion": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
		]
	)
	
	static let ESRI_BusStops_FeatureByID_GET_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .featureByID,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .get,
		header: nil,
		urlParams: [
			"where": "status='Active'",
			"text": "",
			"objectIds": "1540",
			"time": "",
			"geometry": "",
			"geometryType": "esriGeometryEnvelope",
			"inSR": "",
			"spatialRel": "esriSpatialRelIntersects",
			"relationParam": "",
			"outFields": "*",
			"returnGeometry": "true",
			"returnTrueCurves": "false",
			"maxAllowableOffset": "",
			"geometryPrecision": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
			"returnCountOnly": "false",
			"orderByFields": "",
			"groupByFieldsForStatistics": "",
			"outStatistics": "",
			"returnZ": "false",
			"returnM": "false",
			"gdbVersion": "",
			"returnDistinctValues": "false",
			"resultOffset": "",
			"resultRecordCount": "25",
			"f": "json",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_BusStops_FeatureByID_POST_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .featureByID,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .post,
		header: [
			"Content-Type":"application/x-www-form-urlencoded"
		],
		urlParams: nil,
		bodyString: nil,
		bodyForm: [
			"outStatistics": "",
			"objectIds": "1540",
			"returnCountOnly": "false",
			"time": "",
			"relationParam": "",
			"maxAllowableOffset": "",
			"groupByFieldsForStatistics": "",
			"f": "json",
			"resultRecordCount": "25",
			"outFields": "*",
			"geometryType": "esriGeometryEnvelope",
			"geometry": "",
			"spatialRel": "esriSpatialRelIntersects",
			"geometryPrecision": "",
			"returnZ": "false",
			"resultOffset": "",
			"where": "status='Active'",
			"returnGeometry": "true",
			"returnM": "false",
			"text": "",
			"inSR": "",
			"orderByFields": "",
			"returnTrueCurves": "false",
			"returnDistinctValues": "false",
			"gdbVersion": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
		]
	)
	
	static let ESRI_BusStops_AttributeFilter_GET_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .attributeFilter,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .get,
		header: nil,
		urlParams: [
			"where": "location LIKE '%Curtin%' AND status='Active' AND suburb='BENTLEY'",
			"text": "",
			"objectIds": "",
			"time": "",
			"geometry": "",
			"geometryType": "esriGeometryEnvelope",
			"inSR": "",
			"spatialRel": "esriSpatialRelIntersects",
			"relationParam": "",
			"outFields": "stopid,stopnumber,status,stopname,location,stoptype,suburb,bay,shelter,asset,weekpam,weekppm,weekoff,weekrem,satpam,satppm,satoff,satrem,sunphpam,sunphppm,sunphoff,sunphrem,oid",
			"returnGeometry": "true",
			"returnTrueCurves": "false",
			"maxAllowableOffset": "",
			"geometryPrecision": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
			"returnCountOnly": "false",
			"orderByFields": "",
			"groupByFieldsForStatistics": "",
			"outStatistics": "",
			"returnZ": "false",
			"returnM": "false",
			"gdbVersion": "",
			"returnDistinctValues": "false",
			"resultOffset": "",
			"resultRecordCount": "999",
			"f": "json",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_BusStops_AttributeFilter_POST_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .attributeFilter,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .post,
		header: [
			"Content-Type":"application/x-www-form-urlencoded"
		],
		urlParams: nil,
		bodyString: nil,
		bodyForm: [
			"outStatistics": "",
			"objectIds": "",
			"returnCountOnly": "false",
			"time": "",
			"relationParam": "",
			"maxAllowableOffset": "",
			"groupByFieldsForStatistics": "",
			"f": "json",
			"resultRecordCount": "999",
			"outFields": "stopid,stopnumber,status,stopname,location,stoptype,suburb,bay,shelter,asset,weekpam,weekppm,weekoff,weekrem,satpam,satppm,satoff,satrem,sunphpam,sunphppm,sunphoff,sunphrem,oid",
			"geometryType": "esriGeometryEnvelope",
			"geometry": "",
			"spatialRel": "esriSpatialRelIntersects",
			"geometryPrecision": "",
			"returnZ": "false",
			"resultOffset": "",
			"where": "location LIKE '%Curtin%' AND status='Active' AND suburb='BENTLEY'",
			"returnGeometry": "true",
			"returnM": "false",
			"text": "",
			"inSR": "",
			"orderByFields": "",
			"returnTrueCurves": "false",
			"returnDistinctValues": "false",
			"gdbVersion": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
		]
	)
	
	static let ESRI_BusStops_IntersectFilter_GET_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .intersectFilter,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .get,
		header: nil,
		urlParams: [
			"where": "status='Active'",
			"text": "",
			"objectIds": "",
			"time": "",
			"geometry": "115.8860718954193,-32.01350664629256,115.9009673001542,-31.99754322345886",
			"geometryType": "esriGeometryEnvelope",
			"inSR": "4326",
			"spatialRel": "esriSpatialRelIntersects",
			"relationParam": "",
			"outFields": "stopid,stopname,stoptype,status,location,suburb",
			"returnGeometry": "true",
			"returnTrueCurves": "false",
			"maxAllowableOffset": "",
			"geometryPrecision": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
			"returnCountOnly": "false",
			"orderByFields": "stopname",
			"groupByFieldsForStatistics": "",
			"outStatistics": "",
			"returnZ": "false",
			"returnM": "false",
			"gdbVersion": "",
			"returnDistinctValues": "false",
			"resultOffset": "",
			"resultRecordCount": "75",
			"f": "json",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_BusStops_IntersectFilter_POST_JSON = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .intersectFilter,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Maps/Cultural_and_Society/MapServer/1/query",
		method: .post,
		header: [
			"Content-Type":"application/x-www-form-urlencoded"
		],
		urlParams: nil,
		bodyString: nil,
		bodyForm: [
			"outStatistics": "",
			"objectIds": "",
			"returnCountOnly": "false",
			"time": "",
			"relationParam": "",
			"maxAllowableOffset": "",
			"groupByFieldsForStatistics": "",
			"f": "json",
			"resultRecordCount": "75",
			"outFields": "stopid,stopname,stoptype,status,location,suburb",
			"geometryType": "esriGeometryEnvelope",
			"geometry": "115.8860718954193,-32.01350664629256,115.9009673001542,-31.99754322345886",
			"spatialRel": "esriSpatialRelIntersects",
			"geometryPrecision": "",
			"returnZ": "false",
			"resultOffset": "",
			"where": "status='Active'",
			"returnGeometry": "true",
			"returnM": "false",
			"text": "",
			"inSR": "4326",
			"orderByFields": "",
			"returnTrueCurves": "false",
			"returnDistinctValues": "false",
			"gdbVersion": "",
			"outSR": "4326",
			"returnIdsOnly": "false",
		]
	)
	
	static let ESRI_Topo_Small_GET = TETemplate(
		server: .esri,
		dataset: .topo,
		returnType: .image,
		testName: .small,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Services/Medium_Scale_Topo_Public_Services/MapServer/export",
		method: .get,
		header: nil,
		urlParams: [
			"bbox": "115,-35.5,127,-13.5",
			"bboxSR": "4283",
			"layers": "show:0,1,2,3",
			"layerDefs": "",
			"size": "50,50",
			"imageSR": "4283",
			"format": "png",
			"transparent": "true",
			"dpi": "",
			"time": "",
			"layerTimeOptions": "",
			"dynamicLayers": "",
			"gdbVersion": "",
			"mapScale": "",
			"f": "image",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_Topo_Small_POST = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .small,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Services/Medium_Scale_Topo_Public_Services/MapServer/export",
		method: .post,
		header: [
			"Content-Type":"application/x-www-form-urlencoded"
		],
		urlParams: nil,
		bodyString: nil,
		bodyForm: [
			"bboxSR": "4283",
			"layers": "show:0,1,2,3",
			"format": "png",
			"bbox": "115,-35.5,127,-13.5",
			"transparent": "true",
			"size": "50,50",
			"imageSR": "4283",
			"f": "image",
		]
	)
	
	static let ESRI_Topo_Big_GET = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .big,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Services/Medium_Scale_Topo_Public_Services/MapServer/export",
		method: .get,
		header: nil,
		urlParams: [
			"bbox": "115,-35.5,127,-13.5",
			"bboxSR": "4283",
			"layers": "show:0,1,2,3",
			"layerDefs": "",
			"size": "500,500",
			"imageSR": "4283",
			"format": "png",
			"transparent": "true",
			"dpi": "",
			"time": "",
			"layerTimeOptions": "",
			"dynamicLayers": "",
			"gdbVersion": "",
			"mapScale": "",
			"f": "image",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let ESRI_Topo_Big_POST = TETemplate(
		server: .esri,
		dataset: .busStops,
		returnType: .json,
		testName: .big,
		url: "https://services.slip.wa.gov.au/public/rest/services/Landgate_Public_Services/Medium_Scale_Topo_Public_Services/MapServer/export",
		method: .post,
		header: [
			"Content-Type":"application/x-www-form-urlencoded"
		],
		urlParams: nil,
		bodyString: nil,
		bodyForm: [
			"bboxSR": "4283",
			"layers": "show:0,1,2,3",
			"format": "png",
			"bbox": "115,-35.5,127,-13.5",
			"transparent": "true",
			"size": "500,500",
			"imageSR": "4283",
			"f": "image",
		]
	)
	
	// MARK: OGC Requests
	
	static let OGC_BusStops_GetCapabilities_GET_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .getCapabilities,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetCapabilities"
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_GetCapabilities_POST_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .getCapabilities,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<GetCapabilities service=\"WFS\"xmlns=\"http://www.opengis.net/wfs\"xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"xsi:schemaLocation=\"http://www.opengis.net/wfshttp://schemas.opengis.net/wfs/1.1.0/wfs.xsd\"/>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_Small_GET_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .small,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"propertyName": "stopid,status,stopname,stoptype,the_geom",
			"maxFeatures": "25",
			"outputFormat": "json",
			"filter": "<Filter><PropertyIsEqualTo><PropertyName>status</PropertyName><Literal>Active</Literal></PropertyIsEqualTo></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_Small_GET_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .small,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"propertyName": "stopid,status,stopname,stoptype,the_geom",
			"maxFeatures": "25",
			"filter": "<Filter><PropertyIsEqualTo><PropertyName>status</PropertyName><Literal>Active</Literal></PropertyIsEqualTo></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_Small_POST_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .small,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" outputFormat=\"json\" version=\"1.1.0\" service=\"wfs\" maxFeatures=\"25\"><wfs:Query typeName=\"slip:PTA-008\"><wfs:PropertyName>stopid</wfs:PropertyName><wfs:PropertyName>status</wfs:PropertyName><wfs:PropertyName>stopname</wfs:PropertyName><wfs:PropertyName>stoptype</wfs:PropertyName><wfs:PropertyName>the_geom</wfs:PropertyName><ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>status</ogc:PropertyName><ogc:Literal>Active</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_Small_POST_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .small,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" version=\"1.1.0\" service=\"wfs\" maxFeatures=\"25\"><wfs:Query typeName=\"slip:PTA-008\"><wfs:PropertyName>stopid</wfs:PropertyName><wfs:PropertyName>status</wfs:PropertyName><wfs:PropertyName>stopname</wfs:PropertyName><wfs:PropertyName>stoptype</wfs:PropertyName><wfs:PropertyName>the_geom</wfs:PropertyName><ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>status</ogc:PropertyName><ogc:Literal>Active</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_Big_GET_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .big,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"maxFeatures": "500",
			"outputFormat": "json",
			"filter": "<Filter><PropertyIsEqualTo><PropertyName>status</PropertyName><Literal>Active</Literal></PropertyIsEqualTo></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_Big_GET_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .big,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"maxFeatures": "500",
			"filter": "<Filter><PropertyIsEqualTo><PropertyName>status</PropertyName><Literal>Active</Literal></PropertyIsEqualTo></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_Big_POST_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .big,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" outputFormat=\"json\" version=\"1.1.0\" service=\"wfs\" maxFeatures=\"500\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>status</ogc:PropertyName><ogc:Literal>Active</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_Big_POST_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .big,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" version=\"1.1.0\" service=\"wfs\" maxFeatures=\"500\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>status</ogc:PropertyName><ogc:Literal>Active</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_FeatureByID_GET_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .featureByID,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"maxFeatures": "25",
			"outputFormat": "json",
			"filter": "<Filter><PropertyIsEqualTo><PropertyName>gid</PropertyName><Literal>1540</Literal></PropertyIsEqualTo></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_FeatureByID_GET_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .featureByID,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"maxFeatures": "25",
			"filter": "<Filter><PropertyIsEqualTo><PropertyName>gid</PropertyName><Literal>1540</Literal></PropertyIsEqualTo></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_FeatureByID_POST_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .featureByID,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" outputFormat=\"json\" version=\"1.1.0\" service=\"wfs\" maxFeatures=\"25\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>gid</ogc:PropertyName><ogc:Literal>1540</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_FeatureByID_POST_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .featureByID,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" version=\"1.1.0\" service=\"wfs\" maxFeatures=\"25\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>gid</ogc:PropertyName><ogc:Literal>1540</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_AttributeFilter_GET_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .attributeFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"outputFormat": "json",
			"maxFeatures": "25",
			"filter": "<Filter><PropertyIsLike wildCard='*' singleChar='.' escape='!'><PropertyName>location</PropertyName><Literal>Curtin*</Literal></PropertyIsLike></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_AttributeFilter_GET_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .attributeFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"maxFeatures": "25",
			"filter": "<Filter><PropertyIsLike wildCard='*' singleChar='.' escape='!'><PropertyName>location</PropertyName><Literal>Curtin*</Literal></PropertyIsLike></Filter>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_AttributeFilter_POST_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .attributeFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" outputFormat=\"json\" version=\"1.1.0\" service=\"wfs\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:And><ogc:PropertyIsEqualTo><ogc:PropertyName>status</ogc:PropertyName><ogc:Literal>Active</ogc:Literal></ogc:PropertyIsEqualTo><ogc:PropertyIsEqualTo><ogc:PropertyName>suburb</ogc:PropertyName><ogc:Literal>BENTLEY</ogc:Literal></ogc:PropertyIsEqualTo><ogc:PropertyIsLike wildCard='*' singleChar='.' escape='!'><ogc:PropertyName>location</ogc:PropertyName><ogc:Literal>*Curtin*</ogc:Literal></ogc:PropertyIsLike></ogc:And></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_AttributeFilter_POST_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .attributeFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" version=\"1.1.0\" service=\"wfs\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:And><ogc:PropertyIsEqualTo><ogc:PropertyName>status</ogc:PropertyName><ogc:Literal>Active</ogc:Literal></ogc:PropertyIsEqualTo><ogc:PropertyIsEqualTo><ogc:PropertyName>suburb</ogc:PropertyName><ogc:Literal>BENTLEY</ogc:Literal></ogc:PropertyIsEqualTo><ogc:PropertyIsLike wildCard='*' singleChar='.' escape='!'><ogc:PropertyName>location</ogc:PropertyName><ogc:Literal>*Curtin*</ogc:Literal></ogc:PropertyIsLike></ogc:And></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_IntersectFilter_GET_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .intersectFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"outputFormat": "json",
			"maxFeatures": "500",
			"filter": "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" outputFormat=\"json\" version=\"1.1.0\" service=\"wfs\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:BBOX><ogc:PropertyName>the_geom</ogc:PropertyName><gml:Box srsName=\"EPSG:4326\"><gml:coordinates>115.8860718954193,-32.01350664629256 115.9009673001542,-31.99754322345886</gml:coordinates></gml:Box></ogc:BBOX></ogc:Filter></wfs:Query></wfs:GetFeature>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_IntersectFilter_GET_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .intersectFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WFS",
			"version": "1.1.0",
			"request": "GetFeature",
			"typeName": "slip:PTA-008",
			"maxFeatures": "500",
			"filter": "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" outputFormat=\"json\" version=\"1.1.0\" service=\"wfs\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:BBOX><ogc:PropertyName>the_geom</ogc:PropertyName><gml:Box srsName=\"EPSG:4326\"><gml:coordinates>115.8860718954193,-32.01350664629256 115.9009673001542,-31.99754322345886</gml:coordinates></gml:Box></ogc:BBOX></ogc:Filter></wfs:Query></wfs:GetFeature>",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_BusStops_IntersectFilter_POST_JSON = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .json,
		testName: .intersectFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" outputFormat=\"json\" version=\"1.1.0\" service=\"wfs\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:BBOX><ogc:PropertyName>the_geom</ogc:PropertyName><gml:Box srsName=\"EPSG:4326\"><gml:coordinates>115.8860718954193,-32.01350664629256 115.9009673001542,-31.99754322345886</gml:coordinates></gml:Box></ogc:BBOX></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_BusStops_IntersectFilter_POST_XML = TETemplate(
		server: .ogc,
		dataset: .busStops,
		returnType: .xml,
		testName: .intersectFilter,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .post,
		header: [
			"Content-Type" : "text/xml"
		],
		urlParams: nil,
		bodyString: "<wfs:GetFeature xmlns:wfs=\"http://www.opengis.net/wfs\" xmlns:ogc=\"http://www.opengis.net/ogc\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:cgf=\"http://www.opengis.net/cite/geometry\" version=\"1.1.0\" service=\"wfs\"><wfs:Query typeName=\"slip:PTA-008\"><ogc:Filter><ogc:BBOX><ogc:PropertyName>the_geom</ogc:PropertyName><gml:Box srsName=\"EPSG:4326\"><gml:coordinates>115.8860718954193,-32.01350664629256 115.9009673001542,-31.99754322345886</gml:coordinates></gml:Box></ogc:BBOX></ogc:Filter></wfs:Query></wfs:GetFeature>",
		bodyForm: nil
	)
	
	static let OGC_Topo_Small_GET = TETemplate(
		server: .ogc,
		dataset: .topo,
		returnType: .image,
		testName: .small,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: [
			"Authorization" : "Basic YXAxNzg5ODY2MTpTSzJhWFBMRmpJenV0NDc="
		],
		urlParams: [
			"service": "WMS",
			"version": "1.3.0",
			"request": "GetMap",
			"layers": "LGATE-010,LGATE-052,LGATE-053,LGATE-054",
			"srs": "EPSG:4283",
			"bbox": "110,-35.5,132,-13.5",
			"width": "50",
			"height": "50",
			"format": "image/png",
			"transparent": "true",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_Topo_Big_GET = TETemplate(
		server: .ogc,
		dataset: .topo,
		returnType: .image,
		testName: .big,
		url: "https://www2.landgate.wa.gov.au/ows/wfspublic_4326/wfs",
		method: .get,
		header: [
			"Authorization" : "Basic YXAxNzg5ODY2MTpTSzJhWFBMRmpJenV0NDc="
		],
		urlParams: [
			"service": "WMS",
			"version": "1.3.0",
			"request": "GetMap",
			"layers": "LGATE-010,LGATE-052,LGATE-053,LGATE-054",
			"srs": "EPSG:4283",
			"bbox": "110,-35.5,132,-13.5",
			"width": "500",
			"height": "500",
			"format": "image/png",
			"transparent": "true",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_Imagery_Restful_GET = TETemplate(
		server: .ogc,
		dataset: .aerial,
		returnType: .image,
		testName: .getTileRest,
		url: "https://imagery.slip.wa.gov.au/wmts/Locate/wa/19/430928/311390.png",
		method: .get,
		header: nil,
		urlParams: nil,
		bodyString: nil,
		bodyForm: nil
	)
	
	static let OGC_Imagery_KVP_GET = TETemplate(
		server: .ogc,
		dataset: .aerial,
		returnType: .image,
		testName: .getTileKVP,
		url: "https://imagery.slip.wa.gov.au/service",
		method: .get,
		header: nil,
		urlParams: [
			"service": "WMTS",
			"version": "1.0.0",
			"request": "GetTile",
			"layer": "Locate",
			"style": "default",
			"format": "image/png",
			"tilematrixset": "wa",
			"tilematrix": "19",
			"tilerow": "311390",
			"tilecol": "430928",
		],
		bodyString: nil,
		bodyForm: nil
	)
	
	// MARK: Google Maps Engine Requests
	/*
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
*/
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
			downloadSize: 2870, // This was 2100 for the GME version
			testPlan: [
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_Big_GET_JSON,
				TestEndpoint.ESRI_BusStops_Big_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_Big_GET_JSON,
				TestEndpoint.OGC_BusStops_Big_GET_XML,
				TestEndpoint.OGC_BusStops_Big_POST_JSON,
				TestEndpoint.OGC_BusStops_Big_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET
			]
		),
		TMTemplate(
			name: "Extra Long Test",
			details: "A repetitious test over a long period asking for small " +
					"JSON responses over and over and over. This is a good one " +
					"for those times when you're planning on moving about a lot, " +
					"say on the train or bus.",
			image: UIImage(named: "Extra Long Icon")!,
			downloadSize: 2736, // This was 394 for the GME version
			testPlan: [
				TestEndpoint.ESRI_BusStops_GetCapabilities_GET_JSON,
				TestEndpoint.ESRI_BusStops_GetCapabilities_POST_JSON,
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_GetCapabilities_GET_XML,
				TestEndpoint.OGC_BusStops_GetCapabilities_POST_XML,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_XML,
				TestEndpoint.ESRI_BusStops_GetCapabilities_GET_JSON,
				TestEndpoint.ESRI_BusStops_GetCapabilities_POST_JSON,
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_GetCapabilities_GET_XML,
				TestEndpoint.OGC_BusStops_GetCapabilities_POST_XML,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_XML,
				TestEndpoint.ESRI_BusStops_GetCapabilities_GET_JSON,
				TestEndpoint.ESRI_BusStops_GetCapabilities_POST_JSON,
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_GetCapabilities_GET_XML,
				TestEndpoint.OGC_BusStops_GetCapabilities_POST_XML,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_XML,
				TestEndpoint.ESRI_BusStops_GetCapabilities_GET_JSON,
				TestEndpoint.ESRI_BusStops_GetCapabilities_POST_JSON,
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_GetCapabilities_GET_XML,
				TestEndpoint.OGC_BusStops_GetCapabilities_POST_XML,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_XML,
				TestEndpoint.ESRI_BusStops_GetCapabilities_GET_JSON,
				TestEndpoint.ESRI_BusStops_GetCapabilities_POST_JSON,
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_GetCapabilities_GET_XML,
				TestEndpoint.OGC_BusStops_GetCapabilities_POST_XML,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_XML,
				TestEndpoint.ESRI_BusStops_GetCapabilities_GET_JSON,
				TestEndpoint.ESRI_BusStops_GetCapabilities_POST_JSON,
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_GetCapabilities_GET_XML,
				TestEndpoint.OGC_BusStops_GetCapabilities_POST_XML,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_XML
			]
		),
		TMTemplate(
			name: "Remote Area Test",
			details: "A test designed for areas with dodgy signal (some of the " +
					"best places on Earth, frankly). " +
					"Calls for smaller responses.",
			image: UIImage(named: "Remote Area Icon")!,
			downloadSize: 547, // This was 182 for the GME version
			testPlan: [
				TestEndpoint.ESRI_BusStops_Small_GET_JSON,
				TestEndpoint.ESRI_BusStops_Small_POST_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.ESRI_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.ESRI_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.OGC_BusStops_Small_GET_JSON,
				TestEndpoint.OGC_BusStops_Small_GET_XML,
				TestEndpoint.OGC_BusStops_Small_POST_JSON,
				TestEndpoint.OGC_BusStops_Small_POST_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_GET_XML,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_JSON,
				TestEndpoint.OGC_BusStops_FeatureByID_POST_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_GET_XML,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_AttributeFilter_POST_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_GET_XML,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_JSON,
				TestEndpoint.OGC_BusStops_IntersectFilter_POST_XML,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET
			]
		),
		TMTemplate(
			name: "WMS Test",
			details: "This test calls for image responses rather than XML or JSON." +
					"It is designed to look for image flaws that may happen when " +
					"your signal drops out partway through a response.\nImportantly, " +
					"this test can lead to big downloads. Please use it sparingly.",
			image: UIImage(named: "WMS Icon")!,
			downloadSize: 4064, // This was 5843 for the GME version
			testPlan: [
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_Topo_Small_GET,
				TestEndpoint.ESRI_Topo_Small_POST,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_Topo_Small_GET,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET
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
			downloadSize: 13875,  // This was ???? for the GME version
			testPlan: [
				TestEndpoint.ESRI_BusStops_Big_GET_JSON,
				TestEndpoint.ESRI_BusStops_Big_POST_JSON,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_BusStops_Big_GET_JSON,
				TestEndpoint.OGC_BusStops_Big_GET_XML,
				TestEndpoint.OGC_BusStops_Big_POST_JSON,
				TestEndpoint.OGC_BusStops_Big_POST_XML,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_BusStops_Big_GET_JSON,
				TestEndpoint.ESRI_BusStops_Big_POST_JSON,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_BusStops_Big_GET_JSON,
				TestEndpoint.OGC_BusStops_Big_GET_XML,
				TestEndpoint.OGC_BusStops_Big_POST_JSON,
				TestEndpoint.OGC_BusStops_Big_POST_XML,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_BusStops_Big_GET_JSON,
				TestEndpoint.ESRI_BusStops_Big_POST_JSON,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_BusStops_Big_GET_JSON,
				TestEndpoint.OGC_BusStops_Big_GET_XML,
				TestEndpoint.OGC_BusStops_Big_POST_JSON,
				TestEndpoint.OGC_BusStops_Big_POST_XML,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_BusStops_Big_GET_JSON,
				TestEndpoint.ESRI_BusStops_Big_POST_JSON,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_BusStops_Big_GET_JSON,
				TestEndpoint.OGC_BusStops_Big_GET_XML,
				TestEndpoint.OGC_BusStops_Big_POST_JSON,
				TestEndpoint.OGC_BusStops_Big_POST_XML,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET,
				TestEndpoint.ESRI_BusStops_Big_GET_JSON,
				TestEndpoint.ESRI_BusStops_Big_POST_JSON,
				TestEndpoint.ESRI_Topo_Big_GET,
				TestEndpoint.ESRI_Topo_Big_POST,
				TestEndpoint.OGC_BusStops_Big_GET_JSON,
				TestEndpoint.OGC_BusStops_Big_GET_XML,
				TestEndpoint.OGC_BusStops_Big_POST_JSON,
				TestEndpoint.OGC_BusStops_Big_POST_XML,
				TestEndpoint.OGC_Topo_Big_GET,
				TestEndpoint.OGC_Imagery_Restful_GET,
				TestEndpoint.OGC_Imagery_KVP_GET
			]
		)
		
		// MARK: GME TestMaster Templates
		
		/*
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
		*/
	]
}




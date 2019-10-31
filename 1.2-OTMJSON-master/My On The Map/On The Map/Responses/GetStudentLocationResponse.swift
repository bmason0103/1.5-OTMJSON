//
//  GetStudentLocationResponse.swift
//  On The Map
//
//  Created by Brittany Mason on 10/5/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class fullLocationResponse {
    struct LocationResponse {
        var response = "results"
        //String
        var firstName = "first name"
        //String
        var lastName = "last name"
        //String
        var latitude = 0.0
        //Float
        var longitude = 0.0
        //Float
       static var mapStrings = "mapString"
        //String
        var mediaURLs = "media"
        //URL
        var objectID = "objectID"
        //String
        var uniqueKey = "233"
        //Int
        var updatedAt = "updatedAt"
        //String
        var location = "location"
        init() { }
        
        
        init(dictionary: [String: AnyObject]) {
                if let first = dictionary[parametersAll.StudentLocation.firstName] as? String {
                    firstName = first
                }
                if let last = dictionary[parametersAll.StudentLocation.lastName] as? String {
                    lastName = last
                }
                if let objID = dictionary[parametersAll.StudentLocation.objectId] as? String {
                    objectID = objID
                }
                if let uniqKey = dictionary[parametersAll.StudentLocation.uniqueKey] as? String {
                    uniqueKey = uniqKey
                }
                if let mapString = dictionary[parametersAll.StudentLocation.mapString] as? String {
                    LocationResponse.mapStrings = mapString
                }
                if let mediaURL = dictionary[parametersAll.StudentLocation.mediaURL] as? String {
                    mediaURLs = mediaURL
                }
                if let lon = dictionary[parametersAll.StudentLocation.longitude] as? Double {
                    longitude = lon
                }
                if let lat = dictionary[parametersAll.StudentLocation.latitude] as? Double {
                    latitude = lat
                }
            }
            
            static func studentsFromResults(_ results: [[String:AnyObject]]) -> [LocationResponse] {
                
                var students = [LocationResponse]()
                
                // iterate through array of dictionaries, each Movie is a dictionary
                for result in results {
                    students.append(LocationResponse(dictionary: result))
                }
                
                return students
            }
                
        }
        
}
    


//"createdAt": "2015-02-25T01:10:38.103Z",
//          "firstName": "Jarrod",
//          "lastName": "Parkes",
//          "latitude": 34.7303688,
//          "longitude": -86.5861037,
//          "mapString": "Huntsville, Alabama ",
//          "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
//          "objectId": "JhOtcRkxsh",
//          "uniqueKey": "996618664",
//          "updatedAt": "2015-03-09T22:04:50.315Z"

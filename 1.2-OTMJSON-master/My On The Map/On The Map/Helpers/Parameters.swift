//
//  Parameters.swift
//  On The Map
//
//  Created by Brittany Mason on 10/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class parametersAll {
    
    //MARK: Constants
    struct Constants {
        static let studentLocationURL =  "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let sessionURL = "https://onthemap-api.udacity.com/v1/session"
        static let userURL = "https://onthemap-api.udacity.com/v1/users"
    }
    //MARK: Parameters
    struct GetParameter {
        static let limit = "limit"
        //Example: https://onthemap-api.udacity.com/v1/StudentLocation?limit=100
        static let skip = "skip"
        //Example: https://onthemap-api.udacity.com/v1/StudentLocation?limit=200&skip=400
        static let order = "order"
        //Example: https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt
       static var uniqueKey = "uniquekey"
        //Example:String https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey=1234
       static var userID = "userID "
        //String
    }
    
    struct PutParameter {
       static var objectId = "objectID"
        //Example String: https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8
    }
    
    struct PostParameter {
        
        static var udacity = "udacity"
        //[String:String]
        static var username = "username"
        //String
        static var password = "password"
        //String
        
        static var Account = "account"
        //Bool
        static var key = "key"
        //string
        static var userid = "id"
        //string
        static var expiration = "expiration"
        //string
        
    }
    
    //MARK: JSON Response Keys -Student Data
    struct StudentLocation {
        
        static var Response = "results"
        static var objectId = "objectId"
        //String like a user ID
        static var uniqueKey = "uniqueKey"
        //String
        static var firstName = "firstName"
        //String
        static var lastName = "lastName"
        //String
        static var mapString = "mapString"
        //String
        static var mediaURL = "mediaURL"
        //String
        static var latitude = "latitude"
        //Double
        static var longitude = "longitude"
        //Double
        static var createdAt = "createdAt"
        //Date
        static var updatedAt = "updatedAt"
        //Date
        static var studentsLocDict = [fullLocationResponse.LocationResponse]()
        
        
        // *** Public User Data***
        static var user = "user"
        static var publicfirstName = "first_name"
        static var publiclastName = "last_name"
        //       static var ACL:acl_tag_t
        //        //acl_tag_t
    }
    
    struct User{
        var firstName =  "firstName"
        var lastName = "lastName"
        
        }
   
    
    static func escapedParameters(_ parameters: [String:AnyObject]) -> String {
          
          if parameters.isEmpty {
              return ""
          } else {
              var keyValuePairs = [String]()
              
              for (key, value) in parameters {
                  
                  // make sure that it is a string value
                  let stringValue = "\(value)"
                  
                  // escape it
                  let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                  
                  // append it
                  keyValuePairs.append(key + "=" + "\(escapedValue!)")
                  
              }
              
              return "?\(keyValuePairs.joined(separator: "&"))"
          }
        
      }
    
    class func sharedInstance() -> parametersAll {
           struct Singleton {
               static var sharedInstance = parametersAll()
           }
           return Singleton.sharedInstance
       }
}

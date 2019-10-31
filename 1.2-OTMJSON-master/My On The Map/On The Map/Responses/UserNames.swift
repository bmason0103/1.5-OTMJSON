//
//  UserNames.swift
//  On The Map
//
//  Created by Brittany Mason on 10/29/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class userNames {
    struct Users {
        var response = "results"
        //String
        var firstName = "first name"
        //String
        var lastName = "last name"
        //String
        
        init() { }
        
        init(dictionary: [String: AnyObject]) {
                if let first = dictionary[parametersAll.StudentLocation.publiclastName] as? String {
                    firstName = first
                }
                if let last = dictionary[parametersAll.StudentLocation.publiclastName] as? String {
                    lastName = last
                }
            }
            
            static func userNameFromResults(_ results: [[String:AnyObject]]) -> [Users] {
                
                var userNames = [Users]()
                
                // iterate through array of dictionaries, each Movie is a dictionary
                for result in results {
                    userNames.append(Users(dictionary: result))
                }
                
                return userNames
            }
                
        }
        
}
    


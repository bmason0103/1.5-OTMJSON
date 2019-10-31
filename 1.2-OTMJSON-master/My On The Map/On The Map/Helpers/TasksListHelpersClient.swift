//
//  TasksListHelpersClient.swift
//  On The Map
//
//  Created by Brittany Mason on 10/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

//MARK: Common vars to piece together later
class taskslisthelpers {
    
    var session = URLSession.shared
    //REPLACE THIS API KEY WITH SOMETHING REAL
    static let apiKey = "9e1ea9fb0278292ca5c96f4daf886916"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
}




//MARK: List of helper functions to call for login methods
// MARK: -- POST Authentication
/***************************************************************/

func taskPostASessionAuth ( username:String, password:String, _completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    //        udacitydict:[String:String]
    
    let urlString = parametersAll.Constants.sessionURL
    let headerFields = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    
    let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
    
    let task = Client.taskForPOSTMethods(urlString: urlString, headerFields: headerFields, jsonBody: jsonBody) { (results, error) in
        
        if let error = error {
            
            _completionHandlerForAuth(false, error.localizedDescription)
        } else {
            if let account = results?[parametersAll.PostParameter.Account] as? NSDictionary {
                if let accountKey = account[parametersAll.PostParameter.key] as?
                    
                    String{
                    postASessionResponse.SessionResponse.accountKey = accountKey
                    _completionHandlerForAuth(true, nil)
                    print("login successful")
                }
                
            } else {
                print("Could not find \(parametersAll.PostParameter.key) in \(String(describing: results))")
                _completionHandlerForAuth(false, "Invalid Credentials")
                
            }
        }
    }
    
    task.resume()
    
    
}

//* TASK: Get student location, then store it (appDelegate.requestToken) and login with the token */
// MARK: -- GET Student Location
/***************************************************************/
func taskGetStudentLocations (_ completionHandlerForGETStudentLocation: @escaping ( _ result: [fullLocationResponse.LocationResponse]?, _ error: NSError?) -> Void) {
    
    //Set perameters
    let parametersForMethod = [
        parametersAll.GetParameter.limit : 100,
        parametersAll.GetParameter.order : "-updatedAt"
        ] as [String : Any]
    
    //2.3 BUILD THE URL AND CONFIG REQUEST
    let requestURL = parametersAll.Constants.studentLocationURL + parametersAll.escapedParameters (parametersForMethod as [String:AnyObject])
    
    let _ = Client.taskForGETMethod (urlString:requestURL) { (results, error) in
        
        if let error = error {
            
            completionHandlerForGETStudentLocation(nil, error)
        } else {
            if let results = results?[parametersAll.StudentLocation.Response] as? [[String:AnyObject]] {
                // Creates a student object array from results
                let studentInfo = fullLocationResponse.LocationResponse.studentsFromResults(results)
                completionHandlerForGETStudentLocation(studentInfo, nil)
            } else {
                completionHandlerForGETStudentLocation(nil, NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
            }
        }
    }
    
}


// MARK: -- GET Public User Data
/***************************************************************/

func taskgetPublicUserData (_ completionHandlerForUserData: @escaping (_ result:AnyObject?, _ errorString: String?) -> Void) {
    
    let urlString = parametersAll.Constants.userURL + "/\(postASessionResponse.SessionResponse.accountKey)"
    //        let headerFields = [String:String]()
    
    let task = Client.taskForGETMethods(urlString: urlString) { (results, error) in
        
        /* 3. Send the desired value(s) to completion handler */
        if let error = error {
            print(error.localizedDescription)
            completionHandlerForUserData(nil, "There was an error getting user data.")
        }
        else {
            
            if let last_name = results?[parametersAll.StudentLocation.publiclastName] as? String,
                let first_name = results?[parametersAll.StudentLocation.publicfirstName] as? String{
                parametersAll.StudentLocation.publiclastName = last_name
                parametersAll.StudentLocation.publicfirstName = first_name
                let user = parametersAll.User(firstName: first_name, lastName: last_name)
                completionHandlerForUserData (user as AnyObject, nil)
            }
                
            else  {
                print("Could not find \(parametersAll.StudentLocation.user) in \(String(describing: results))")
                completionHandlerForUserData(nil,"Could not get the user data.")
                print(postASessionResponse.SessionResponse.accountKey)
            }
        }
    }
    task.resume()
    
}


// MARK: -- POST Student Session
/***************************************************************/

func taskPostStudentLocation(_ completionHandlerForPostStudentLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
    /* 1. Build the URL */
    let requestURL = parametersAll.Constants.studentLocationURL
    /* JSON Body */
    //set peramaters
    let locationResponse = fullLocationResponse.LocationResponse()
    let jsonBody = "{\"uniqueKey\": \"\(postASessionResponse.SessionResponse.accountKey)\", \"firstName\": \"\(parametersAll.StudentLocation.publicfirstName)\", \"lastName\": \"\(parametersAll.StudentLocation.publiclastName)\",\"mapString\": \"\(parametersAll.StudentLocation.mapString)\", \"mediaURL\": \"\(parametersAll.StudentLocation.mediaURL)\",\"latitude\":\(locationResponse.latitude), \"longitude\": \(locationResponse.longitude)}"
    print(jsonBody)
//    parametersAll.PostParameter.key

    let headerFields = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    
    /* 2. Make the request */
    let task = Client.taskForPOSTMethod (urlString:requestURL, headerFields: headerFields, jsonBody: jsonBody) { (results, error) in
        
        
        /* 3. Send the desired value(s) to completion handler */
        if let error = error {
            completionHandlerForPostStudentLocation(nil, error)
        } else {
            if let objectId = results?[postLocationResponse.postLocationResponse.objectId] as? String {
                completionHandlerForPostStudentLocation(objectId, nil)
            } else {
                print(completionHandlerForPostStudentLocation(nil, NSError(domain: "postNewStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"])))
            }
        }
        
    }
    
    task.resume()
}



// MARK: -- DELETE A Session
/***************************************************************/
func taskDeleteASession (){
    
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        //     let range = Range(5..<data!.count)
        //   let newData = data?.subdata(in: range) /* subset response data! */
        //   print(String(data: newData!, encoding: .utf8)!)
    }
    task.resume()
    
}






// MARK: -- Logout the User
/***************************************************************/



func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    let urlString = parametersAll.Constants.userURL
    
    let request = NSMutableURLRequest(url:URL(string:urlString)!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies!
        
    {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    
    let task = Client.taskForDELETEMethod (request as URLRequest) { (results, error) in
        
        if let error = error {
            print(error.localizedDescription)
            completionHandlerForLogout(false, "There was an error with logout.")
        } else {
        
                completionHandlerForLogout(true, nil)
            print("logged out")
                                               
        }
    }
}
//            else {
//                print("Could not find \([parametersAll.PostParameter.key]) in \(String(describing: results))")
//                completionHandlerForLogout(false, "Could not logout.")
//            }



//        if let session = results?[parametersAll.Constants.sessionURL] as? NSDictionary {
//                                if let expiration = session[parametersAll.PostParameter.expiration] as? String{
//                                    print("logged out: \(expiration)")
//                                    completionHandlerForLogout(true, nil)






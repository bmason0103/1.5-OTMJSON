//
//  Methods.swift
//  On The Map
//
//  Created by Brittany Mason on 10/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class Client: NSObject {
    
    // MARK: - Properties
    /***************************************************************/
    
    var session = URLSession.shared
    
    // MARK: -- GET Method for student location
    /***************************************************************/
    
    static func taskForGETMethod(urlString: String, _ completionHandlerForGETMethod: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //        let peramaters = parametersAll.GetParameter.limit
        /* Build the URL, Configure the request */
        let urlString = urlString
        
        let request = NSMutableURLRequest(url:URL(string:urlString)!)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        /* Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                
                completionHandlerForGETMethod(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("Error occured: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            if urlString == parametersAll.Constants.sessionURL  {
                let range = Range(uncheckedBounds: (5, data.count))
                let newData = data.subdata(in: range) /* subset response data! */
                /* Parse the data and use the data */
                Client.self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGETMethod)
            } else {
                Client.self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGETMethod)
                
            }
            //            let range = Range(uncheckedBounds: (5, data.count))
            //            let newData = data.subdata(in: range) /* subset response data! */
            //
            //                Client.self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGETMethod)
        }
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: -- GET Method for user data
    /***************************************************************/
    
    static func taskForGETMethods(urlString: String, _ completionHandlerForGETMethod: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //        let peramaters = parametersAll.GetParameter.limit
        /* Build the URL, Configure the request */
        let urlString = urlString
        
        let request = NSMutableURLRequest(url:URL(string:urlString)!)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        /* Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                
                completionHandlerForGETMethod(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("Error occured: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            //                if urlString == parametersAll.Constants.sessionURL  {
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            /* Parse the data and use the data */
            Client.self.convertDataWithCompletionHandlerNFrag(newData, completionHandlerForConvertData: completionHandlerForGETMethod)
            //                    } else {
            //                        Client.self.convertDataWithCompletionHandlerNFrag(data, completionHandlerForConvertData: completionHandlerForGETMethod)
            
            //                    }
            //            let range = Range(uncheckedBounds: (5, data.count))
            //            let newData = data.subdata(in: range) /* subset response data! */
            //
            //                Client.self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGETMethod)
        }
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: -- POST Method
    /***************************************************************/
    
    static func taskForPOSTMethod(urlString: String, headerFields:[String:String], jsonBody: String, completionHandlerForPOSTMethod: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var session = URLSession.shared
        /* Build the URL, Configure the request */
        let urlString = urlString
        let request = NSMutableURLRequest(url:URL(string:urlString)!)
        request.httpMethod = "POST"
        
        for (field, value) in headerFields {
            request.addValue(value, forHTTPHeaderField: field)
        }
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                //print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOSTMethod(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                // MARK: Check for login credentials.
                if let data = data {
                    if urlString == parametersAll.Constants.sessionURL {
                        let range = Range(uncheckedBounds: (5, data.count))
                        let newData = data.subdata(in: range)
                        /* Parse the data and use the data */
                        Client.self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOSTMethod)
                    }
                } else {
                    sendError("Your request returned a status code other than 2xx!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if urlString == parametersAll.Constants.sessionURL  {
                let range = Range(uncheckedBounds: (5, data.count))
                let newData = data.subdata(in: range) /* subset response data! */
                /* Parse the data and use the data */
                Client.self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOSTMethod)
            } else {
                Client.self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOSTMethod)
            }
            
        }
        
        /* Start the request */
        task.resume()
        
        return task
        
    }
    
    
    // MARK: -- ^^^TEST^^ POST Method
    /***************************************************************/
    
    static func taskForPOSTMethods(urlString: String, headerFields:[String:String], jsonBody: String, completionHandlerForPOSTMethod: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var session = URLSession.shared
        /* Build the URL, Configure the request */
        let urlString = urlString
        let request = NSMutableURLRequest(url:URL(string:urlString)!)
        request.httpMethod = "POST"
        
        for (field, value) in headerFields {
            request.addValue(value, forHTTPHeaderField: field)
        }
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                //print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOSTMethod(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                // MARK: Check for login credentials.
                if let data = data {
                    if urlString == parametersAll.Constants.sessionURL {
                        let range = Range(uncheckedBounds: (5, data.count))
                        let newData = data.subdata(in: range)
                        /* Parse the data and use the data */
                        Client.self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOSTMethod)
                    }
                } else {
                    sendError("Your request returned a status code other than 2xx!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
              let range = Range(uncheckedBounds: (5, data.count))
                     let newData = data.subdata(in: range) /* subset response data! */
                     /* Parse the data and use the data */
                     Client.self.convertDataWithCompletionHandlerNFrag(newData, completionHandlerForConvertData: completionHandlerForPOSTMethod)
            
        }
        
        /* Start the request */
        task.resume()
        
        return task
        
    }
    
    
    
    
    // MARK: -- DELETE Method
    /***************************************************************/
    
    static func taskForDELETEMethod(_ request: URLRequest, completionHandlerForDELETEMethod: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
       var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETEMethod(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            
            /* Parse the data and use the data (happens in completion handler) */
            Client.self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETEMethod)
        }
        
        /* Start the request */
        task.resume()
        
        }
        
    }
    

    
    // MARK: -- Helper Methods
    /***************************************************************/
    
    /* Parse Data Method */
    static func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            //            parsedResult = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    static func convertDataWithCompletionHandlerNFrag(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            //                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    /* Escaped Paramets Method */
    func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
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
}

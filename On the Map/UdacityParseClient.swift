//
//  UdacityParseClient.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

class UdacityParseClient: NSObject {
    
    // MARK: Properties
    var session = NSURLSession.sharedSession()
    
    // Configuration Object
//    var config = UdacityParseConfig()
    
    // Authentication State
    var applicationId: String? = nil
    var ApiKey: String? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    func taskForGETMethod(resource: String, parameters inputParameters: [String:AnyObject], completionHandlerForGet: (results: AnyObject!, error: NSError?) -> Void) ->NSURLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: resource))
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: RequestKeys.ApplicationIdHeader)
        request.addValue(Constants.APIKey, forHTTPHeaderField: RequestKeys.RESTAPIKey)
        
        // (4) Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Custom error function
            func sendError(error:String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(results: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard error == nil else {
                sendError("There was an error with the request: \(error)")
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where 200...299 ~= statusCode else {
                sendError("Request returned a status code other that 2XX!")
                return
            }
            
            // GUARD: Was any data returned?
            guard var data = data else {
                sendError("No data returned by the request")
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        // (7) Start request
        task.resume()
        
        return task
    }
    
    // MARK: POST
    func taskForPOSTMethod(resource: String, parameters inputParameters: [String:AnyObject], JSONBody inputJSONBody: [String:AnyObject], completionHandlerForPost: (results: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: resource))
        request.HTTPMethod = "POST"
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: RequestKeys.ApplicationIdHeader)
        request.addValue(Constants.APIKey, forHTTPHeaderField: RequestKeys.RESTAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = convertObjectToJSONData(inputJSONBody)
                
        // (4) Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Custom error function
            func sendError(error:String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(results: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard error == nil else {
                sendError("There was an error with the request: \(error)")
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where 200...299 ~= statusCode else {
                sendError("Request returned a status code other that 2XX!\n" + "\(response)")
                return
            }
            
            // GUARD: Was any data returned?
            guard var data = data else {
                sendError("No data returned by the request")
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        // (7) Start request
        task.resume()
        
        return task
    }
    
    // MARK: PUT
    func taskForPUTMethod(resource: String, parameters inputParameters: [String:AnyObject], JSONBody inputJSONBody: [String:AnyObject], completionHandlerForPost: (results: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: resource))
        request.HTTPMethod = "PUT"
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: RequestKeys.ApplicationIdHeader)
        request.addValue(Constants.APIKey, forHTTPHeaderField: RequestKeys.RESTAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = convertObjectToJSONData(inputJSONBody)
        
        // (4) Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Custom error function
            func sendError(error:String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(results: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard error == nil else {
                sendError("There was an error with the request: \(error)")
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where 200...299 ~= statusCode else {
                sendError("Request returned a status code other that 2XX!\n" + "\(response)")
                return
            }
            
            // GUARD: Was any data returned?
            guard var data = data else {
                sendError("No data returned by the request")
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        // (7) Start request
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    // given a Dictionary, return a JSON String
    private func convertObjectToJSONData(object: AnyObject) -> NSData{
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions(rawValue: 0))
        }
        catch {
            return NSData()
        }
        
        return parsedResult as! NSData
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
//        let data = inputData.subdataWithRange(NSMakeRange(5, inputData.length - 5))
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // create a URL from parameters
    private func URLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityParseClient {
        struct Singleton {
            static var sharedInstance = UdacityParseClient()
        }
        return Singleton.sharedInstance
    }
}
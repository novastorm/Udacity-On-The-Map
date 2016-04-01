//
//  UdacityClient.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

enum MFDUdacityClientErrorCodes: Int {
    case GenericError
    case NetworkError
    case GenericRequestError
    case HTTPUnsucessful
    case NoData
}

extension MFDUdacityClientErrorCodes: CustomStringConvertible {
    var description: String {
        get {
            switch self {
            case .GenericError:
                return "Generic Error"
            case .NetworkError:
                return "Network Error"
            case .GenericRequestError:
                return "There was an error with the request."
            case .HTTPUnsucessful:
                return "Request returned a status code other that 2XX!"
            case .NoData:
                return "No data returned by the request"
            }
        }
    }
}

class UdacityClient: NSObject {
    
    // MARK: Properties
    var session = NSURLSession.sharedSession()
    
    // Configuration Object
    var config = UdacityConfig()
    
    // Authentication State
    var sessionId: String? = nil
    var accountKey: String? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    func taskForGETMethod(resource: String, parameters inputParameters: [String:AnyObject], completionHandlerForGet: (results: AnyObject!, error: NSError?) -> Void) ->NSURLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: resource))
        
        // (4) Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Custom error function
            func sendError(code: Int, errorString:String) {
                var userInfo = [String: AnyObject]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["http_response"] = response
                
                completionHandlerForGet(results: nil, error: NSError(domain: "taskForGetMethod", code: code, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            if let error = error {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where 200...299 ~= statusCode else {
                sendError(MFDUdacityClientErrorCodes.HTTPUnsucessful.rawValue, errorString: MFDUdacityClientErrorCodes.HTTPUnsucessful.description)
                return
            }
            
            // GUARD: Was any data returned?
            guard var data = data else {
                sendError(MFDUdacityClientErrorCodes.NoData.rawValue, errorString: MFDUdacityClientErrorCodes.NoData.description)
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
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
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = convertObjectToJSONData(inputJSONBody)
                
        // (4) Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Custom error function
            func sendError(code: Int, errorString:String) {
                var userInfo = [String: AnyObject]()

                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["http_response"] = response
                
                completionHandlerForPost(results: nil, error: NSError(domain: "taskForPostMethod", code: code, userInfo: userInfo))
            }
            
            if let error = error {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where 200...299 ~= statusCode else {
                sendError(MFDUdacityClientErrorCodes.HTTPUnsucessful.rawValue, errorString: MFDUdacityClientErrorCodes.HTTPUnsucessful.description)
                return
            }
            
            // GUARD: Was any data returned?
            guard var data = data else {
                sendError(MFDUdacityClientErrorCodes.NoData.rawValue, errorString: MFDUdacityClientErrorCodes.NoData.description)
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        // (7) Start request
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    func taskForDELETEMethod(resource: String, parameters inputParameters: [String:AnyObject], completionHandlerForDelete: (results: AnyObject!, error: NSError?) -> Void) ->NSURLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: resource))
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // (4) Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Custom error function
            func sendError(code: Int, errorString:String) {
                var userInfo = [String: AnyObject]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["http_response"] = response
                
                completionHandlerForDelete(results: nil, error: NSError(domain: "taskForDeleteMethod", code: code, userInfo: userInfo))
            }
            
            
            // GUARD: Was there an error?
            if let error = error {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where 200...299 ~= statusCode else {
                sendError(MFDUdacityClientErrorCodes.HTTPUnsucessful.rawValue, errorString: MFDUdacityClientErrorCodes.HTTPUnsucessful.description)
                return
            }
            
            // GUARD: Was any data returned?
            guard var data = data else {
                sendError(MFDUdacityClientErrorCodes.NoData.rawValue, errorString: MFDUdacityClientErrorCodes.NoData.description)
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDelete)
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
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func clearData () {
        accountKey = nil
    }
}
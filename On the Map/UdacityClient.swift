//
//  UdacityClient.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

// MARK: UdacityClient

class UdacityClient {

    // MARK: Shared Instance
    static let sharedInstance = UdacityClient()
    fileprivate init() {} // Disable default initializer

    // MARK: Properties
    var session = URLSession.shared
    
    // Authentication State
    var sessionId: String? = nil
    var accountKey: String? = nil
    
    var account: Account? = nil
    
    /*
     Special Note on Udacity JSON Responses
     
     FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
     These characters are used for security purposes. In the examples, you will see that we subset the response data in order to skip over them.
     */
    fileprivate func trimSecurityfrom(_ data: Data) -> Data {
        return data.subdata(in: 5 ..< data.count)
    }
    
    // MARK: GET
    func taskForGETMethod(_ resource: String, parameters inputParameters: [String:AnyObject], completionHandlerForGet: @escaping (_ results: Any?, _ error: NSError?) -> Void) ->URLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        var request = URLRequest(url: URLFromParameters(parameters, withPathExtension: resource))
        
        // (4) Make request
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            // Custom error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["http_response"] = response
                
                completionHandlerForGet(nil, NSError(domain: "taskForGetMethod", code: code, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            if let error = error as? NSError {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode else {
                sendError(ErrorCodes.httpUnsucessful.rawValue, errorString: ErrorCodes.httpUnsucessful.description)
                return
            }
            
            // GUARD: Was any data returned?
            guard let data = data else {
                sendError(ErrorCodes.noData.rawValue, errorString: ErrorCodes.noData.description)
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            self.convertDataWithCompletionHandler(self.trimSecurityfrom(data), completionHandlerForConvertData: completionHandlerForGet)
        }) 
        
        // (7) Start request
        task.resume()
        
        return task
    }
    
    // MARK: POST
    func taskForPOSTMethod(_ resource: String, parameters inputParameters: [String:AnyObject], JSONBody inputJSONBody: [String:AnyObject], completionHandlerForPost: @escaping (_ results: Any?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        var request = URLRequest(url: URLFromParameters(parameters, withPathExtension: resource))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = convertObjectToJSONData(inputJSONBody as AnyObject)
                
        // (4) Make request
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            // Custom error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()

                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["http_response"] = response
                
                completionHandlerForPost(nil, NSError(domain: "taskForPostMethod", code: code, userInfo: userInfo))
            }
            
            // Check for error
            if let error = error as? NSError {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode else {
                sendError(ErrorCodes.httpUnsucessful.rawValue, errorString: ErrorCodes.httpUnsucessful.description)
                return
            }
            
            // GUARD: Was any data returned?
            guard let data = data else {
                sendError(ErrorCodes.noData.rawValue, errorString: ErrorCodes.noData.description)
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            self.convertDataWithCompletionHandler(self.trimSecurityfrom(data), completionHandlerForConvertData: completionHandlerForPost)
        }) 
        
        // (7) Start request
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    func taskForDELETEMethod(_ resource: String, parameters inputParameters: [String:AnyObject], completionHandlerForDelete: @escaping (_ results: Any?, _ error: NSError?) -> Void) ->URLSessionDataTask {
        
        // (1) Set Parameters
        var parameters = inputParameters
        
        // (2) Build URL, (3) Configure Request
        var request = URLRequest(url: URLFromParameters(parameters, withPathExtension: resource))
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // (4) Make request
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            // Custom error function
            func sendError(_ code: Int, errorString:String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["http_response"] = response
                
                completionHandlerForDelete(nil, NSError(domain: "taskForDeleteMethod", code: code, userInfo: userInfo))
            }
            
            
            // GUARD: Was there an error?
            if let error = error as? NSError {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            // GUARD: Was a successul 2XX response received?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode else {
                sendError(ErrorCodes.httpUnsucessful.rawValue, errorString: ErrorCodes.httpUnsucessful.description)
                return
            }
            
            // GUARD: Was any data returned?
            guard let data = data else {
                sendError(ErrorCodes.noData.rawValue, errorString: ErrorCodes.noData.description)
                return
            }
            
            // (5) Parse and (6) use data with completion handler
            self.convertDataWithCompletionHandler(self.trimSecurityfrom(data), completionHandlerForConvertData: completionHandlerForDelete)
        }) 
        
        // (7) Start request
        task.resume()
        
        return task
    }
    
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given a Dictionary, return a JSON String
    fileprivate func convertObjectToJSONData(_ object: AnyObject) -> Data{
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) as AnyObject!
        }
        catch {
            return Data()
        }
        
        return parsedResult as! Data
    }
    
    // given raw JSON, return a usable Foundation object
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: Any?, _ error: NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the client data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    fileprivate func URLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}

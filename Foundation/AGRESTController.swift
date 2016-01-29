//
//  AGRESTController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Alamofire

typealias RESTResultBlock = (result : AnyObject?) -> Void

class AGRESTController : Manager {
    private var backgroundQueue : dispatch_queue_t?
    private let version         = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String

    /*Auth*/
    private var username, password: String?
    var baseUrl, token : String?

    let dateFormatter   = NSDateFormatter()
    
    /*Developer*/
    var logEnable   = false
    private var _logString = String()
    func logString() -> String {
        return _logString
    }
    func logClear() {
        _logString.removeAll()
    }
    
    private func appendConcsoleLog( text : String) {
        if logEnable {
            _logString.appendContentsOf(text)
        }
    }

    init(queue : dispatch_queue_t?) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        super.init(configuration: configuration)
        
        self.backgroundQueue = queue ?? dispatch_queue_create("BackgroundQueue", DISPATCH_QUEUE_CONCURRENT)
        self.dateFormatter.dateFormat   = "yyyy-MM-dd HH:mm"
        self.dateFormatter.timeZone     = NSTimeZone(name: "UTC")
        
    }
    
    convenience init(baseUrl : String) {
        self.init(queue : nil)
        self.baseUrl = baseUrl
    }
    
    let defaultManager: Alamofire.Manager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "test.example.com": .PinCertificates(
                certificates: ServerTrustPolicy.certificatesInBundle(),
                validateCertificateChain: false,
                validateHost: true
            ),
            "insecure.expired-apis.com": .DisableEvaluation
        ]
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        
        return Alamofire.Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()

    private func URLStringForMethod(methodString : String) -> String {
        let urlString   = self.baseUrl!.stringByAppendingString(methodString)
        return urlString
    }
    
    func requestJSON(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [ String : AnyObject ]? = nil, encoding: ParameterEncoding = .URL, resultBlock : RESTResultBlock ) -> Request {
        var headers : [String : String]? = nil
        if self.token != nil {
            headers = [:]
            headers!["token"]        = self.token
        }
        self.appendConcsoleLog("[\(dateFormatter.stringFromDate(NSDate()))] Start <\(method)> \(URLString)\n {\(parameters)}\n")
        return super.request(method, URLString, parameters: parameters, encoding: encoding, headers: headers).response(queue: self.backgroundQueue, completionHandler: {[weak self] (NSURLRequest, NSHTTPURLResponse, NSData, error) -> Void in
            if NSHTTPURLResponse?.statusCode == 401 {
                /*Session expired*/
                self?.token = nil
                self!.appendConcsoleLog("End Session Invalid 401\n==================\n")
                /*Call userSignIn method*/
            }
            else {
                if NSHTTPURLResponse != nil {
                    self!.appendConcsoleLog("[\(self!.dateFormatter.stringFromDate(NSDate()))] End (\(NSHTTPURLResponse!.statusCode)) \(URLString) ")
                }
                else {
                    self!.appendConcsoleLog("[\(self!.dateFormatter.stringFromDate(NSDate()))] End \(URLString) ")
                }
                if error != nil {
                    self!.appendConcsoleLog("\(error!.localizedDescription)\n==================\n")
                    resultBlock(result: error)
                }
                else {
                    
                    guard let validData = NSData where validData.length > 0 else {
                        let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                        let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                        self!.appendConcsoleLog("\(error.localizedDescription)\n==================\n")
                        
                        resultBlock(result: error)
                        return
                    }
                    
                    do {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: .AllowFragments)
                        self!.appendConcsoleLog("\(JSON)\n==================\n")
                        
                        resultBlock(result: JSON)
                    } catch let error as NSError {
                        self!.appendConcsoleLog("\(error.localizedDescription)\n==================\n")
                        resultBlock(result: error)
                        }
                    }
                }
            })
    }
}
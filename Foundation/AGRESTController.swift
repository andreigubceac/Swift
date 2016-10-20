//
//  AGRESTController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Alamofire

typealias RESTResultBlock = (_ result : Any) -> Void

class AGRESTController : SessionManager {
    fileprivate var backgroundQueue = DispatchQueue(label: "BackgroundQueue", qos : DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 0))

    /*Auth*/
    fileprivate var username, password: String?
    var baseUrl : String!
    var token   : String?

    let dateFormatter   = DateFormatter()
    
    /*Developer*/
    var logEnable   = false
    fileprivate var _logString = String()
    func logString() -> String {
        return _logString
    }
    func logClear() {
        _logString.removeAll()
    }
    
    fileprivate func appendConcsoleLog(_ text : String) {
        if logEnable {
            _logString.append(text)
        }
    }

    init(serverTrustPolicyManager : ServerTrustPolicyManager? = nil) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        super.init(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: serverTrustPolicyManager)
        dateFormatter.dateFormat   = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone     = TimeZone(identifier : "UTC")
    }
    
    convenience init(baseUrl : String) {
        self.init()
        self.baseUrl = baseUrl
    }

    func URLStringForMethod(_ methodString : String) -> URLConvertible {
        let urlString   = baseUrl + methodString
        return urlString
    }
    
    func requestJSON(method: HTTPMethod = .get,
                     url: URLConvertible,
                     parameters: Parameters? = nil,
                     encoding: ParameterEncoding  = URLEncoding.default,
                     resultBlock : @escaping RESTResultBlock ) -> Request {
        
        appendConcsoleLog("[\(dateFormatter.string(from: Date()))] Start <\(method)> \(url)\n {\(parameters)}\n")
        let headers = authorizeRequest()
        
        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).response(completionHandler: {(dataResponse) in
            if let statusCode = dataResponse.response?.statusCode, statusCode == 401 {
                /*Session expired*/
                self.appendConcsoleLog("End Session Invalid 401\n==================\n")
                /*Call userSignIn method*/
                self.autosignInRequest(request: dataResponse.request!, completion: { (result) in
                    if result is NSError {
                        resultBlock(result)
                    }
                    else {
                        let _ = self.requestJSON(method: method, url: url, parameters: parameters, encoding: encoding, resultBlock: resultBlock)
                    }
                })
            }
            else {
                if let statusCode = dataResponse.response?.statusCode {
                    self.appendConcsoleLog("[\(self.dateFormatter.string(from: Date()))] End (\(statusCode)) \(url) ")
                }
                else {
                    self.appendConcsoleLog("[\(self.dateFormatter.string(from: Date()))] End \(url) ")
                }
                if let error = dataResponse.error {
                    self.appendConcsoleLog("\(error.localizedDescription)\n==================\n")
                    resultBlock(error)
                }
                else {
                    
                    guard let validData = dataResponse.data, validData.count > 0 else {
                        let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                        let error = NSError(domain: "API", code: 500, userInfo: [NSLocalizedDescriptionKey : failureReason])
                        self.appendConcsoleLog("\(error.localizedDescription)\n==================\n")
                        
                        resultBlock(error)
                        return
                    }
                    
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                        self.appendConcsoleLog("\(JSON)\n==================\n")
                        resultBlock(JSON)
                    } catch let error as NSError {
                        self.appendConcsoleLog("Error = \(error.localizedDescription)\nText\(String(data: validData, encoding: .utf8)))\n==================\n")
                        resultBlock(error)
                    }
                }
            }
        })
    }
    
    /*Sign The Request*/
    
    func autosignInRequest(request : URLRequest, completion : @escaping RESTResultBlock) {
        /*override*/
        token = nil
    }
    
    func authorizeRequest() -> HTTPHeaders? {
        /*Override this method*/
        return nil
    }
    
    /*APNs*/
    func logRemoteNotification(_ userInfo : Dictionary<AnyHashable,Any>) -> Void {
        appendConcsoleLog("\nAPNs - Start ===============\n")
        if let dictionary = userInfo["aps"] as? NSDictionary {
            appendConcsoleLog(dictionary.description)
        }
        appendConcsoleLog("\nAPNs - End  ================\n")
    }
}

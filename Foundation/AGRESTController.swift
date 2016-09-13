//
//  AGRESTController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Alamofire

typealias RESTResultBlock = (_ result : Any?) -> Void

class AGRESTController : SessionManager {
    private var backgroundQueue = DispatchQueue(label: "BackgroundQueue", qos : DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 0))

    /*Auth*/
    private var username, password: String?
    var baseUrl, token : String?

    let dateFormatter   = DateFormatter()
    
    /*Developer*/
    var logEnable   = false
    private var _logString = String()
    func logString() -> String {
        return _logString
    }
    func logClear() {
        _logString.removeAll()
    }
    
    private func appendConcsoleLog( _ text : String) {
        if logEnable {
            _logString.append(text)
        }
    }

    init(serverTrustPolicyManager : ServerTrustPolicyManager? = nil) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        super.init(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: serverTrustPolicyManager)
        self.dateFormatter.dateFormat   = "yyyy-MM-dd HH:mm"
        self.dateFormatter.timeZone     = TimeZone(identifier : "UTC")
    }
    
    convenience init(baseUrl : String) {
        self.init()
        self.baseUrl = baseUrl
    }

    func URLStringForMethod(_ methodString : String) -> String {
        let urlString   = self.baseUrl! + methodString
        return urlString
    }
    
    func requestJSON(_ method: HTTPMethod, _ URLString: URLStringConvertible, parameters: [ String : AnyObject ]? = nil, encoding: ParameterEncoding = .url, resultBlock : RESTResultBlock ) -> Request {
        let headers = self.authorizeRequest()
        self.appendConcsoleLog("[\(dateFormatter.string(from: Date()))] Start <\(method)> \(URLString)\n {\(parameters)}\n")
        return super.request(URLString, withMethod: method, parameters: parameters, encoding: encoding, headers: headers).response { (URLRequest, HTTPURLResponse, Data, error) in
            if HTTPURLResponse?.statusCode == 401 {
                /*Session expired*/
                self.appendConcsoleLog("End Session Invalid 401\n==================\n")
                /*Call userSignIn method*/
                self.autosignInRequest(URLRequest!, completion: { (result) in
                    if result is NSError {
                        resultBlock(result)
                    }
                    else {
                        let _ = self.requestJSON(method, URLString, parameters: parameters, encoding: encoding, resultBlock: resultBlock)
                    }
                })
            }
            else {
                if HTTPURLResponse != nil {
                    self.appendConcsoleLog("[\(self.dateFormatter.string(from: Date()))] End (\(HTTPURLResponse!.statusCode)) \(URLString) ")
                }
                else {
                    self.appendConcsoleLog("[\(self.dateFormatter.string(from: Date()))] End \(URLString) ")
                }
                if error != nil {
                    self.appendConcsoleLog("\(error!.localizedDescription)\n==================\n")
                    resultBlock(error)
                }
                else {
                    
                    guard let validData = Data , validData.count > 0 else {
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
                        self.appendConcsoleLog("Error = \(error.localizedDescription)\nText\(NSString(data: validData, encoding: 4)))\n==================\n")
                        resultBlock(error)
                    }
                }
            }
        }
    }
    
    /*Sign The Request*/
    
    func autosignInRequest(_ request : URLRequest, completion : RESTResultBlock) -> Void {
        /*override*/
        self.token = nil
    }
    
    func authorizeRequest() -> [String : String]? {
        /*Override this method*/
        return nil
    }
    
    /*APNs*/
    func logRemoteNotification(_ userInfo : Dictionary<AnyHashable,Any>) -> Void {
        self.appendConcsoleLog("\nAPNs - Start ===============\n")
        if let dictionary = userInfo["aps"] as? NSDictionary {
            self.appendConcsoleLog(dictionary.description)
        }
        self.appendConcsoleLog("\nAPNs - End  ================\n")
    }
}

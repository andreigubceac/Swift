//
//  AGRESTController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Alamofire

public extension AGRESTController {
    static let forceLogoutNotification = Notification.Name("AGRESTController.forceLogoutNotification")
}

open class AGRESTController {
    private var backgroundQueue = DispatchQueue(label: "BackgroundQueue", qos : DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 0))
    typealias RESTResultBlock = (_ result: Swift.Result<Any?, Error>) -> Void

    /*Auth*/
    fileprivate var username, password: String?
    let baseUrl: String
    var token   : String?
    let session: Session

    var dateFormatter: DateFormatter {
        return DateFormatter.sharedFormatter()
    }
    
    /*Developer*/
    var isLogEnable = false
    private var _logString = String()
    func logString() -> String {
        return _logString
    }
    func logClear() {
        _logString.removeAll()
    }
    
    func appendConcsoleLog(_ text : String) {
        if isLogEnable {
            _logString.append(text)
        }
    }

    init(baseUrl : String, session: Session) {
      self.baseUrl = baseUrl
      self.session = session
    }

    func URLStringForMethod(_ methodString : String) -> URLConvertible {
        let urlString   = baseUrl + methodString
        return urlString
    }
    private var retryLoginCount = 0
    @discardableResult
    func request(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil, resultBlock : @escaping RESTResultBlock) -> Request? {
        if retryLoginCount > 0 { return nil }
        
        appendConcsoleLog("[\(dateFormatter.string(from: Date()))] Start <\(method)> \(url)\n {\(String(describing: parameters))}\n")
        var _headers = authorizeRequest()
        headers?.forEach { _headers?.add($0) }

        #if targetEnvironment(simulator)
        debugPrint(method.rawValue + ": " + (try! url.asURL().absoluteString))
        debugPrint("Params: " + (parameters?.description ?? ""))
        #endif

        return session.request(url, method: method, parameters: parameters, encoding: encoding, headers: _headers).response(queue: backgroundQueue, completionHandler: {[weak self] dataResponse in
            guard let self = self else { return }
            if let statusCode = dataResponse.response?.statusCode, statusCode == 401 {
                /*Session expired*/
                self.appendConcsoleLog("End Session Invalid 401\n==================\n")
                /*Call userSignIn method*/
                if self.retryLoginCount < 3 {
                    let loginCount = self.retryLoginCount
                    self.retryLoginCount = 0
                    self.autosignInRequest(request: dataResponse.request!, completion: { (result) in
                      switch result {
                      case .failure(let error):
                        resultBlock(Swift.Result.failure(error))
                      case .success(_):
                        self.retryLoginCount = 0
                        let parameters = self.updateOnAutoSingFailed(parameters: parameters)
                        let _ = self.request(url, method: method, parameters: parameters, encoding: encoding, resultBlock: resultBlock)
                      }
                    })
                    self.retryLoginCount = loginCount + 1
                } else {
                    self.retryLoginCount = 0
                    NotificationCenter.default.post(name: AGRESTController.forceLogoutNotification, object: nil)
                }
            } else {
                if let statusCode = dataResponse.response?.statusCode {
                    self.appendConcsoleLog("[\(self.dateFormatter.string(from: Date()))] End (\(statusCode)) \(url) ")
                } else {
                    self.appendConcsoleLog("[\(self.dateFormatter.string(from: Date()))] End \(url) ")
                }
                if let error = dataResponse.error {
                    self.appendConcsoleLog("\(error.localizedDescription)\n==================\n")
                    resultBlock(Swift.Result.failure(error))
                } else if let data = dataResponse.data {
                    #if targetEnvironment(simulator)
                        debugPrint(url)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        debugPrint(json)
                    }
                    catch {
                        debugPrint(error)
                        debugPrint(String(data: data, encoding: .utf8) ?? "")
                    }
                    #endif
                    resultBlock(Swift.Result.success(data))
                } else {
                    resultBlock(Swift.Result.success(dataResponse))
                }
            }
        })
    }
    @discardableResult
    func requestJSON(method: HTTPMethod = .get,
                     url: URLConvertible,
                     parameters: Parameters? = nil,
                     encoding: ParameterEncoding  = URLEncoding.default,
                     resultBlock : @escaping RESTResultBlock ) -> Request? {
        return request(url, method: method, parameters: parameters, encoding: encoding, resultBlock: { [weak self] result in
            guard let self = self else { return }
          switch result {
          case .failure(let error):
            resultBlock(Swift.Result.failure(error))
          case .success(let result):
            guard let validData = result as? Data, validData.count > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = NSError(domain: "API", code: 500, userInfo: [NSLocalizedDescriptionKey : failureReason])
                self.appendConcsoleLog("\(error.localizedDescription)\n==================\n")
                return resultBlock(Swift.Result.failure(error))
            }
            do {
                let JSON = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                self.appendConcsoleLog("\(JSON)\n==================\n")
                resultBlock(Swift.Result.success(JSON))
            } catch let error as NSError {
                self.appendConcsoleLog("Error = \(error.localizedDescription)\nText\(String(describing: String(data: validData, encoding: .utf8))))\n==================\n")
                resultBlock(Swift.Result.failure(error))
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
    
    func updateOnAutoSingFailed(parameters: Parameters?) ->Parameters? {
        // override
        return parameters
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

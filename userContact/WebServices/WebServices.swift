//
//  WebServices.swift
//  userContact
//
//  Created by Khadim Hussain on 25/10/2021.
//

import UIKit
import Alamofire

typealias apiSuccess = (_ data: Data) -> ()
typealias apiFailure = (_ errorString: String) -> ()
typealias HTTPfailure = (_ errorString: String) -> ()

class WebServices {
    
    class func URLResponse(_ url:String, method: HTTPMethod ,parameters: [String: Any]?, headers: String?,  withSuccess success: @escaping apiSuccess, withapiFiluer failure: @escaping apiFailure) {
        
        let completeUrl : String = Constants.apiBaseUrl + url
        print(completeUrl)
        let headersToken =  HTTPHeaders()
        AF.request(completeUrl, method:method, parameters: parameters, encoding: URLEncoding.httpBody, headers:headersToken).validate(statusCode: 200..<600).responseData(completionHandler: {   respones in
            switch respones.result {
                
            case .success(let value):
                
                success(value)
                
            case .failure(let error):
                failure(error.localizedDescription)
            }
        })
    }
}



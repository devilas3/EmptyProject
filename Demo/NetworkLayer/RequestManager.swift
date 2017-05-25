//
//  RequestManager.swift
//  Demo
//
import Foundation
import Alamofire

class RequestManager: NSObject
{
    /**
     Function to call GET API with url

     - Parameter query: Web API url

     - Returns: completion handle with result or error
     */

    func requestUrl( query: String,completion:@escaping (_ result: AnyObject, _ error: AnyObject)->Void)
    {
        Alamofire.request(query.replacingOccurrences(of: " ", with: "")).responseJSON { response in
                switch response.result
                {
                case .success: //success
                    if let value = response.result.value
                    {
                        completion(value as AnyObject, "" as AnyObject)
                    }
                    else if let value = response.result.error
                    {
                        completion("" as AnyObject, value as AnyObject )
                    }
                case .failure(let error): //error
                    completion("" as AnyObject, error as AnyObject)
                }
        }
    }
}

//
//  DataManager.swift
//  Demo
//
import Foundation

class DataManager: NSObject {

    func getProductsFromApi( _ strUrl : String, completion:@escaping (_ result: AnyObject, _ error: AnyObject)->Void)
    {

        let manager = RequestManager()

        manager.requestUrl(query: strUrl) { (result, error) in
            if error.isKind(of: NSError.classForCoder()) //Error
            {
                completion("" as AnyObject, error)
            }
            else
            {
                //Parse result
                let manager = ParseManager()
                let arrPosts = manager.parseProductsFromJson(result: result)
                completion(arrPosts as AnyObject, "" as AnyObject)
            }

        }
    }
}



//
//  ParseManager.swift
//  Demo
//
import Foundation
import SwiftyJSON

class ParseManager: NSObject
{
    /**
     This parse post from the response

     - Parameter result: get posts from json response

     - Returns: Array of Post entity
     */
    func parseProductsFromJson(result : AnyObject) -> [Products]
    {
        let json = JSON(result)
        var arrProducts = [Products]()

        if !json.isEmpty
        {
            guard json["products"].count > 0 else {
                return arrProducts
            }

            if let arrData = json["products"].array
            {
                for i in 0..<arrData.count
                {
                    if let objProducts = Products(JSONString: arrData[i].description)
                    {
                        objProducts.id = i
                        arrProducts.append(objProducts)
                    }
                }
            }
        }
        return arrProducts
    }
}



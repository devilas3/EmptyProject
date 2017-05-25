

import RealmSwift
import ObjectMapper

class Products: Object,Mappable {

    dynamic var productname = ""
    dynamic var price = ""
    dynamic var vendorname = ""
    dynamic var vendoraddress = ""
    dynamic var productImg = ""
    dynamic var productGallery = ""
    dynamic var phoneNumber = ""
    dynamic var id = 0
    dynamic var quantity = 1


    override static func primaryKey() -> String? {
        return "id"
    }


    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        productname <- map["productname"]
        price <- map["price"]
        vendorname <- map["vendorname"]
        vendoraddress <- map["vendoraddress"]
        productImg <- map["productImg"]
        productGallery <- map["productGallery"]
        phoneNumber <- map["phoneNumber"]
    }
}



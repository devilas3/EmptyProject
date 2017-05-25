//
//  CartTVC.swift
//  Demo
//
//  Copyright © 2017 Suraj. All rights reserved.
//

import UIKit


class CartTVC: UITableViewCell {

    @IBOutlet weak var imgViwProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var lblVendorAddress: UILabel!
    @IBOutlet weak var btnCallVendor: UIButton!
    @IBOutlet weak var btnRemoveFromCart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

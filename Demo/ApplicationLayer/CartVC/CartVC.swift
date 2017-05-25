//
//  CartVC.swift
//  Demo
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class CartVC: BaseVC,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // MARK:- IBOutlet Declaration
    @IBOutlet var lblTotalCost: UILabel!
    @IBOutlet var tblCart: UITableView!

    // MARK:- Variable Declaration
    let productsInCart = try! Realm().objects(Products.self).sorted(byKeyPath: "id")
    var notificationToken: NotificationToken?
    let realm = try! Realm()


    // MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCart.emptyDataSetSource = self
        self.tblCart.emptyDataSetDelegate = self

        self.tblCart.tableFooterView = UIView ()

        self.notificationToken = productsInCart.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tblCart?.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tblCart?.reloadData()
                /*self.tblCart?.beginUpdates()
                self.tblCart?.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)

                self.tblCart?.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)

                self.tblCart?.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)

                self.tblCart?.endUpdates()*/
            case .error(let err):
                fatalError("\(err)")
            }
            self.calculateTotalValue()
        }
        calculateTotalValue()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.visibleViewController?.title = "Cart"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- UITableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return productsInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTVC

        if let url = URL(string: productsInCart[indexPath.row].productImg)
        {
            cell.imgViwProduct.sd_setShowActivityIndicatorView(true)
            cell.imgViwProduct.sd_setIndicatorStyle(.gray)
            cell.imgViwProduct.sd_setImage(with: url)
        }


        cell.lblProductName.text = productsInCart[indexPath.row].productname
        cell.lblVendorName.text = productsInCart[indexPath.row].vendorname
        cell.lblVendorAddress.text = productsInCart[indexPath.row].vendoraddress
        cell.lblPrice.text = rupee + productsInCart[indexPath.row].price
        cell.lblQuantity.text = "Quantity : \(productsInCart[indexPath.row].quantity)"


        cell.btnCallVendor.tag = indexPath.row

        cell.btnCallVendor.addTarget(self, action:#selector(CartVC.callToVendor(_:)), for: UIControlEvents.touchUpInside)
        cell.btnCallVendor.layer.borderColor = UIColor.darkGray.cgColor
        cell.btnCallVendor.layer.borderWidth = 1
        cell.btnCallVendor.layer.cornerRadius = 5


        cell.btnRemoveFromCart.tag = indexPath.row

        cell.btnRemoveFromCart.addTarget(self, action:#selector(CartVC.removeFromCart(_:)), for: UIControlEvents.touchUpInside)
        cell.btnRemoveFromCart.layer.borderColor = UIColor.darkGray.cgColor
        cell.btnRemoveFromCart.layer.borderWidth = 1
        cell.btnRemoveFromCart.layer.cornerRadius = 5

        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10.0
//    }

    // MARK:- DZNEmpty Delegate and DataSetSource

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let strTitle = "No Products in cart"

        let attributes = [NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular" , size: 16.0)! ]

        let attributetTitle = NSAttributedString(string: strTitle, attributes: attributes)

        return attributetTitle
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let strTitle = "Please add from Products Tab"

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center

        let attributes = [NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular" , size: 12.0)!,NSParagraphStyleAttributeName:paragraph ]

        let attributetTitle = NSAttributedString(string: strTitle, attributes: attributes)

        return attributetTitle
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -20
    }

    // MARK:- User Defined Functions

    func callToVendor(_ sender:UIButton)
    {
        //get Paticular object
        let objProduct = productsInCart[sender.tag]
        if let phoneNumberURL:URL = URL(string: "tel://\(objProduct.phoneNumber)") {
            if (UIApplication.shared.canOpenURL(phoneNumberURL)) {
                UIApplication.shared.open(phoneNumberURL, options: [ : ], completionHandler: nil)
            }
            else{
                showAlert("Alert",message: strUnableToCallVendor)
            }
        }
    }

    func removeFromCart(_ sender:UIButton) {
        let productToBeRemoved = productsInCart[sender.tag]
        let productName = productToBeRemoved.productname
        try! self.realm.write({
            self.realm.delete(productToBeRemoved)
        })

        showAlert("Alert", message: "Removed \(productName) from cart.")
    }

    func calculateTotalValue() {
        var totalCost = 0

        for product in self.productsInCart
        {
            if let price = Int(product.price)
            {
                totalCost += product.quantity * price
            }
        }

        self.lblTotalCost.text = "Total Price : " + rupee + "\(totalCost)"
    }

}

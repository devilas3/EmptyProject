//
//  ProductsVC.swift
//  Demo
//

import UIKit
import RealmSwift
import EZLoadingActivity
import SDWebImage

class ProductsVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource {
    // MARK:- IBOutlet Declaration
    @IBOutlet var collViewProducts: UICollectionView!

    // MARK:- Variable Declaration
    let realm = try! Realm()
    var arrProducts = [Products]()

    // MARK:- View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getProductList()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.visibleViewController?.title = "Shop"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Collection View Delegates and DataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }

        let widthAvailbleForAllItems =  (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)

        var widthForOneItem:CGFloat = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            widthForOneItem = widthAvailbleForAllItems / 4 - flowLayout.minimumInteritemSpacing
        }
        else
        {
            widthForOneItem = widthAvailbleForAllItems / 2 - flowLayout.minimumInteritemSpacing
        }

        let heightForOneItem = widthForOneItem / 0.75

        return CGSize(width: widthForOneItem, height: heightForOneItem)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductsCVC

        let objEntProduct = arrProducts[indexPath.row]

        if let url = URL(string: objEntProduct.productImg)
        {
            cell.imgViwProduct.sd_setShowActivityIndicatorView(true)
            cell.imgViwProduct.sd_setIndicatorStyle(.gray)
            cell.imgViwProduct.sd_setImage(with: url)
        }

        cell.lblProductName.text = objEntProduct.productname
        cell.lblVendorName.text = objEntProduct.vendorname
        cell.lblVendorAddress.text = objEntProduct.vendoraddress
        cell.lblProductPrice.text = rupee + objEntProduct.price

            //appDelegate!.getCurrencyFormate(objEntProduct.strPrice)
        cell.btnAddToCart.tag = indexPath.row
        cell.btnAddToCart.addTarget(self, action: #selector(ProductsVC.addToCart(_:)), for: UIControlEvents.touchUpInside)

        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 5

        cell.btnAddToCart.layer.borderColor = UIColor.darkGray.cgColor
        cell.btnAddToCart.layer.borderWidth = 2
        cell.btnAddToCart.layer.cornerRadius = 5
        return cell
    }

    // MARK:- Api Calls
    func getProductList() {
        EZLoadingActivity.show("Loading...", disableUI: true)
        let objDataManager = DataManager()

        objDataManager.getProductsFromApi(strGetProducts) { (result, error) in

            if error.isKind(of: NSError.classForCoder()) //Error code
            {
                EZLoadingActivity.hide(false, animated: true)
                self.checkForServerError(code: error.code)
            }
            else
            {
                EZLoadingActivity.hide(true, animated: true)
                if result is [Products]
                {
                    self.arrProducts = result as! [Products]
                    self.collViewProducts?.reloadData()
                }
            }
        }
    }

    // MARK:- Other User Defined Methods

    func addToCart(_ sender:UIButton)
    {
        addProductToDB(arrProducts[sender.tag])
    }

    func addProductToDB(_ objProduct:Products)
    {
        let exstingPorductFromCart = realm.objects(Products.self).filter("id == \(objProduct.id)").first
        if let _ = exstingPorductFromCart
        {
            try! realm.write {
                exstingPorductFromCart!.quantity += 1
            }
        }
        else
        {
            try! realm.write {
                self.realm.add(objProduct, update: true)
            }
        }

        showAlert("Alert", message: "Added \(objProduct.productname) to cart.")
    }

    /**
     To check for the server error or internet connection and to show message

     - Parameter code: error code

     */
    func checkForServerError(code : NSInteger)
    {
        var strMsg = ""

        if(code == -1009) //if it is -1009 then show internet connection error
        {
            strMsg = strNoInternetConnection
        }
        else //server error
        {
            strMsg = strSomethigWentWrongRetry
        }

        let alertController = UIAlertController(title: "Product Demo", message: strMsg, preferredStyle: .alert)

        let retryAction = UIAlertAction(title: "Retry", style: .default) {
            (result : UIAlertAction) -> Void in
            self.getProductList()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {
            (result : UIAlertAction) -> Void in
        }

        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }


}

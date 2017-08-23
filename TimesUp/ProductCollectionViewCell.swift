//
//  ProductCollectionViewCell.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/21/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit
import StoreKit

class ProductCollectionViewCell: UICollectionViewCell {
   
    // MARK: Outlets
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var accessoryView: UIView!
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    
    // MARK: Properties
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            productTitleLabel?.text = product.localizedTitle
            
            if TimesUpProducts.store.isProductPurchased(product.productIdentifier) {
                
                for subview in accessoryView.subviews {
                    subview.removeFromSuperview()
                }
                // product has been bought.  Figure out logic of what to do
            } else if IAPHelper.canMakePayments() {
                // product has not been bought and the person is allowed to make payments.  No child lock on account.
                ProductCollectionViewCell.priceFormatter.locale = product.priceLocale
                //                detailTextLabel?.text = ProductCell.priceFormatter.string(from: product.price)
                //
                //                accessoryType = .none
                accessoryView.backgroundColor = UIColor.darkGray
                accessoryView.addSubview(newBuyButton())
                accessoryView.layer.cornerRadius = 8.0

            }
            
            else {
                // Person has not bought this but they are not allowed to buy items. Parent lock, etc.
                
                accessoryView.backgroundColor = UIColor.darkGray
                accessoryView.addSubview(newNotAvailableLabel())
                accessoryView.layer.cornerRadius = 8.0

            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productTitleLabel?.text = ""
        for subview in accessoryView.subviews {
            subview.removeFromSuperview()
        }

    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Buy", for: UIControlState())
        button.addTarget(self, action: #selector(ProductCollectionViewCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.layer.frame = CGRect(x: 0, y: 0, width: 101, height: 40)

        return button
    }
    
    func newNotAvailableLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 101, height: 40))
        label.font = UIFont(name: "Avenir", size: 18.0)
        label.text = "Not Availabe"
        label.textColor = UIColor.white
        
        return label
    }
    
    func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }

    
    
    
}

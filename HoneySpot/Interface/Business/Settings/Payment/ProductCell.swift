//
//  ProductCell.swift
//  HoneySpot
//
//  Created by htcuser on 28/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    
    return formatter
  }()
  
  var buyButtonHandler: ((_ product: SKProduct) -> Void)?
  
  var product: SKProduct? {
    didSet {
      guard let product = product else { return }

      //textLabel?.text = product.localizedTitle

      if HoneySpotProducts.store.isProductPurchased(product.productIdentifier) {
        textLabel?.text = "\(product.localizedTitle)"
        accessoryType = .checkmark
        accessoryView = nil
        detailTextLabel?.text = ""
      } else if IAPHelper.canMakePayments() {
        ProductCell.priceFormatter.locale = product.priceLocale
        textLabel?.text = "\(product.localizedTitle)"
        detailTextLabel?.text = ProductCell.priceFormatter.string(from: product.price)
        accessoryType = .none
        accessoryView = self.newBuyButton()
      } else {
        detailTextLabel?.text = "Not available"
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    textLabel?.text = ""
    detailTextLabel?.text = ""
    accessoryView = nil
  }
  
  func newBuyButton() -> UIButton {
    let button = UIButton(type: .system)
    button.setTitleColor(tintColor, for: .normal)
    button.setTitle("Buy", for: .normal)
    button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
    button.sizeToFit()
    
    return button
  }
  
  @objc func buyButtonTapped(_ sender: AnyObject) {
    buyButtonHandler?(product!)
  }
}

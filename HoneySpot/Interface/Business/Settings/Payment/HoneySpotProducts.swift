//
//  HoneySpotProducts.swift
//  HoneySpot
//
//  Created by htcuser on 28/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import Foundation

public struct HoneySpotProducts {
  
  public static let SwiftShopping = "com.honeyspothtc.app.nonconsumablehoney"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [HoneySpotProducts.SwiftShopping]

  public static let store = IAPHelper(productIds: HoneySpotProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}

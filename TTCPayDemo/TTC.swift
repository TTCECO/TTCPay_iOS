//
//  TTC.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/13.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit
import TTCPay

class TTC: NSObject {
    
    static let shared: TTC = TTC()
    var TTCPrice: Double = 0
    
    func fetchPrice() {
        TTCPay.shared.fetchPrice(currencyType: 2) { (success, price, error) in
            if success {
                self.TTCPrice = Double(price!) ?? 0
            }
        }
    }
}

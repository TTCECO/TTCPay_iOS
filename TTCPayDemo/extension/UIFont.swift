//
//  UIFont.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/11.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

extension UIFont {
    static func appFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
    
    static func appBoldFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size)!
    }
}

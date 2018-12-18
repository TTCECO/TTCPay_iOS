//
//  UIColor.swift
//  TTC_Wallet_iOS
//
//  Created by zhangliang on 2018/7/2.
//  Copyright © 2018 tataufo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIColor {
    
    /// 白色
    static let appWhite = UIColor.white
    
    /// 深蓝
    static let appBlue = UIColor(hex: "01028D")

    ///黑色
    static let appBlack = UIColor(hex: "2B2E3D")

    /// 辅助文字颜色
    static let appGray = UIColor(hex: "B6BBC4")
    
    /// 文字背景颜色
    static let appLightGray = UIColor(hex: "ECF0F7")
    
    /// 红色
    static let appRed = UIColor(hex: "FF6067")
    
    /// 深灰
    static let appDarkGray = UIColor(hex: "FFFFFF")
    
    /// 绿色
    static let appGreen = UIColor(hex: "03F083")
    
    /// 灰色阴影
    static let appShadowGrayColor = UIColor(hex: "00113E")

}

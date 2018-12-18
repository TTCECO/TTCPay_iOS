//
//  UIDevice.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/12.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

extension UIDevice {
    /// 是否为iPhoneX
    /// 采用屏幕分辨率的方式
    /// - Returns: 是否为iPhoneX
    public func iPhoneX() -> Bool {
        
        /// 横屏和竖屏时宽高刚好相反，所以需要用最大值来判断！！！
        let height = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        return abs(height - 812) < 1
    }
    
    var bottomSafeMargin: CGFloat {
        get {
            if iPhoneX() {
                return 34
            } else {
                return 0
            }
        }
    }
}

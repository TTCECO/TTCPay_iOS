//
//  UIImage.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/12.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

// MARK: 颜色转UIImage
extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        context?.setShouldAntialias(true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
}

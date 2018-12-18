//
//  TTCNavigationController.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/12.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

class TTCNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
        automaticallyAdjustsScrollViewInsets = false
        
        if #available(iOS 11.0, *) {
        } else {
            /// 主要用户隐藏navbar下的黑线，ios11以后不需要隐藏，且如果ios11之后设置此代码会导致在侧边导航栏透明
            navigationBar.setBackgroundImage(UIImage(color: UIColor.appWhite), for: .default)
        }
        
        /// 隐藏导航栏阴影
        navigationBar.shadowImage = UIImage()
        // 背景色
        navigationBar.barTintColor = UIColor.appWhite
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // initWithRootViewController时也会调用到pushviewcontroller方法，
        // 所以需要做判断在initWithRootViewController时不要走到下面的方法，
        // 否则会导致除刚启动时选中的tabbar之外点击其它tab会隐藏tabbar的情况。
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

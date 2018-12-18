//
//  TTCBaseViewController.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/12.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

class TTCBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIView()
        view.backgroundColor = UIColor.appWhite
        navigationController?.navigationBar.tintColor = UIColor.appBlack
    }
}

//
//  TTCShoppingCartViewController.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/12.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit
import BigInt

struct Order {
    var outTradeNo = ""
    var description_p = ""
    var totalFee: Int = 0
    var createTime: Int64 = 0
    var expireTime: Int64 = 0
}

class TTCShoppingCartViewController: TTCBaseViewController {

    var removeBlock: ((TTCGoods) -> Void)?
    var shopCarts: [TTCGoods] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Cart"
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        
        totalPrice()
    }

    // MARK: - lazy
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        tableView.register(TTCShopCartTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.appWhite
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
        return tableView
    }()
    
    lazy var bottomView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.appWhite
        view.frame = CGRect(x: 0, y: screenHeight-44-UIDevice.current.bottomSafeMargin, width: screenWidth, height: 44+UIDevice.current.bottomSafeMargin)
        
        let label = UILabel()
        label.font = UIFont.appBoldFont(18)
        label.textColor = UIColor.appRed
        label.frame = CGRect(x: 20, y: 0, width: 150, height: 44)
        label.text = "Total: $0"
        label.tag = 100
        view.addSubview(label)
        
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-127, y: 0, width: 127, height: 44)
        button.backgroundColor = UIColor.appBlack
        button.setTitleColor(UIColor.appWhite, for: .normal)
        button.setTitle("Checkout", for: .normal)
        button.addTarget(self, action: #selector(checkOut), for: .touchUpInside)
        view.addSubview(button)
        
        return view
    }()
    
}

// MARK: - common
extension TTCShoppingCartViewController {
    
    func totalPrice() {
        var total = 0
        shopCarts.forEach { (item) in
            total += item.price
        }
        
        let label: UILabel = bottomView.viewWithTag(100) as! UILabel

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.maximumFractionDigits = 0
        
        let currency = numberFormatter.string(from: NSNumber(value: total))
        
        if let num = currency {
            label.text = "Total: \(num)"
        } else {
            label.text = "Total: $\(total)"
        }
    }
}

// MARK: - action
extension TTCShoppingCartViewController {
    
    @objc func checkOut() {
        
        let maps = shopCarts.map { (item) -> String in
            return item.name+", "+item.description
        }
        
        let des = maps.joined(separator: " | ")
        
        var total = 0
        shopCarts.forEach { (item) in
            total += item.price
        }
        let createTime: Int64 = Int64(Date().timeIntervalSince1970*1000)
        let num = arc4random()
        let order = Order(outTradeNo: num.description, description_p: des, totalFee: total, createTime: createTime, expireTime: createTime+60*15*1000)
        
        let checkout = TTCCheckoutViewController()
        checkout.order = order
        self.navigationController?.pushViewController(checkout, animated: true)
    }
}

// MARK: - DataSource
extension TTCShoppingCartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopCarts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TTCShopCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TTCShopCartTableViewCell
        
        cell.setData(data: shopCarts[indexPath.row])
        
        return cell
    }
}

// MARK: - Delegate
extension TTCShoppingCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action = UITableViewRowAction(style: .default, title: "Delete", handler: { [weak self] (_, index) in
            let data = self?.shopCarts[index.row]
            self?.shopCarts.remove(at: index.row)
            self?.removeBlock?(data!)
            self?.tableView.deleteRows(at: [index], with: .automatic)
            self?.totalPrice()
        })
        
        action.backgroundColor = UIColor.appRed
        
        return [action]
    }
}

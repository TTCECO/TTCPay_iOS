//
//  TTCCheckoutViewController.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/13.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit
import TTCPay

struct TTCPayment {
    
    var name = ""
    var imageName = ""
    
    var image: UIImage? {
        get {
            return UIImage(named: self.imageName)
        }
    }
    
    var selectImage: UIImage? {
        get {
            return UIImage(named: self.imageName+"_Checked")
        }
    }
}

class TTCCheckoutViewController: TTCBaseViewController {

    var order: Order?
    var TTCPrice: Double = 0
    var currentPay: TTCPayment?
    
    var payments: [TTCPayment] {
        get {
            return [
            TTCPayment(name: "Paypal", imageName: "Paypal"),
            TTCPayment(name: "TTC Connect", imageName: "TTC"),
            TTCPayment(name: "Apple Pay", imageName: "ApplePay"),
            TTCPayment(name: "Mastercard", imageName: "MasterCard")]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Checkout"

        view.addSubview(tableView)
        
        TTCPrice = TTC.shared.TTCPrice
        
        fetchTTCPrice()
    }
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        tableView.register(TTCCheckoutTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.appWhite
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        
        return tableView
    }()

    lazy var paymentButton: UIButton = {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: screenHeight-UIDevice.current.bottomSafeMargin-49, width: screenWidth, height: 49+UIDevice.current.bottomSafeMargin)
        button.setTitleColor(UIColor.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.appBoldFont(18)
        button.addTarget(self, action: #selector(payment), for: .touchUpInside)
        
        if UIDevice.current.iPhoneX() {
            button.titleEdgeInsets = UIEdgeInsets(top: -15, left: 0, bottom: 20, right: 0)
        }
        
        return button
    }()
}

// MARK: - common
extension TTCCheckoutViewController {
    
    func fetchTTCPrice() {
        TTCPay.shared.fetchPrice(currencyType: 2) { (success, price, error) in
            if success, let ttcprice = price, let ttcDouble = Double(ttcprice) {
                TTC.shared.TTCPrice = ttcDouble
                self.TTCPrice = ttcDouble
            }
        }
    }
}

// MARK: - action
extension TTCCheckoutViewController {
    
    @objc func payment() {
        
        if currentPay?.name == "TTC Connect", let order = order {
            
            let createOrder = TTCCreateOrder()
            createOrder.appId = TTCPay.shared.appId
            createOrder.createTime = order.createTime
            createOrder.expireTime = order.expireTime // 15分钟
            createOrder.description_p = order.description_p
            createOrder.outTradeNo = order.outTradeNo
            let total = Double(order.totalFee)/TTCPrice/100000
            createOrder.totalFee = EtherNumberFormatter.shared.number(from: "\(total)")?.description ?? ""
            
            if createOrder.totalFee.isEmpty {
                return
            }
            
            createOrder.requestSign = TTCSign.signOrder(order: createOrder)
            
            TTCPay.shared.createOrderAndPay(createOrder: createOrder) { (success, orderResult, error) in
                if success, orderResult != nil {
                    print("create success : \(orderResult!.orderId.description)")
                } else {
                    print("create failed：%@", error?.errorDescription ?? "")
                }
            }
            
            TTCPay.shared.payBack = { success, order, error in
                if success, order != nil, !order!.txHash.isEmpty {
                    print("txhash: ",order?.txHash ?? "txhash")
                    
                    let transaction = TTCTransactionViewController()
                    transaction.closeBlock = { state in
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                            switch state {
                            case 2, 3:
                                self.navigationController?.popToRootViewController(animated: true)
                            case 4, 5:
                                self.navigationController?.popToRootViewController(animated: true)
                            default:
                                break
                            }
                        })
                    }
                    transaction.order = order
                    let nav = TTCNavigationController.init(rootViewController: transaction)
                    self.present(nav, animated: true, completion: {
                    })
                    
                } else {
                    print(error?.errorDescription ?? "error")
                }
            }
        }
    }
}

// MARK: - DataSource
extension TTCCheckoutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TTCCheckoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TTCCheckoutTableViewCell
        
        cell.setData(data: payments[indexPath.row])
        
        return cell
    }
}

// MARK: - Delegate
extension TTCCheckoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let payment = payments[indexPath.row]
        currentPay = payment
        view.addSubview(paymentButton)
        
        switch payment.name {
        case "TTC Connect":
            paymentButton.backgroundColor = UIColor.appBlue
            
            if let order = order, TTCPrice != 0 {
                
                let total = Double(order.totalFee)/TTCPrice/100000
                let numberFormatter = NumberFormatter()
                numberFormatter.maximumFractionDigits = 6
                numberFormatter.minimumIntegerDigits = 1
                
                let totalString = numberFormatter.string(from: NSNumber(value: total))
                var text = ""
                
                if let string = totalString {
                    text = "Pay \(string) TTC"
                } else {
                    text = "Pay \(total) TTC"
                }
                paymentButton.setTitle(text, for: .normal)
            }
            
        default:
            
            paymentButton.backgroundColor = UIColor.appRed
 
            if let order = order {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = Locale(identifier: "en_US")
                numberFormatter.maximumFractionDigits = 0
                
                let currency = numberFormatter.string(from: NSNumber(value: order.totalFee))
                var text = ""
                
                if let num = currency {
                    text = "Pay \(num)"
                } else {
                    text = "Pay $\(order.totalFee)"
                }
                
                paymentButton.setTitle(text, for: .normal)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

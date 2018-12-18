//
//  TTCTransactionViewController.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/13.
//  Copyright © 2018 chenchao. All rights reserved.
//


import UIKit
import BigInt
import TTCPay

class TTCTransactionViewController: TTCBaseViewController {

    var closeBlock: ((Int32) -> Void)?
    var order: TTCOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment Detail"
        self.navigationItem.titleView = titleView
        view.addSubview(tableView)
        
        fetchOrder(orderID: order!.orderId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        tableView.register(TTCTransactionInfoTableViewCell.self, forCellReuseIdentifier: "infoCell")
        tableView.register(TTCTransactionValueTableViewCell.self, forCellReuseIdentifier: "valueCell")
        tableView.backgroundColor = UIColor.appWhite
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
   
    lazy var titleView: UIView = {
        
        let view: UIView = UIView()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        
        let label = UILabel()
        label.font = UIFont.appBoldFont(34)
        label.textColor = UIColor.appBlack
        label.textAlignment = .center
        label.frame = CGRect(x: screenWidth/2-150, y: 0, width: 300, height: 44)
        label.text = "Payment Detail"
        view.addSubview(label)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        view.addSubview(button)
        
        return view
    }()
}

// MARK: - action
extension TTCTransactionViewController {
    
    @objc func leftClick() {

        self.closeBlock?(order!.state)
        self.dismiss(animated: true) {
        }
    }
}

// MARK: - common
extension TTCTransactionViewController {
    
    func fetchOrder(orderID: String) {
        if let currOrder = order {
            switch currOrder.state {
            case 2:
                TTCPay.shared.fetchOrder(orderId: orderID) { [weak self] (success, data, error) in
                    if success, let fetOrder = data {
                        self?.order = fetOrder
                        self?.tableView.reloadData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        self?.fetchOrder(orderID: orderID)
                    })
                }
            default:
                break
            }
        }
    }
}

// MARK: - DataSource
extension TTCTransactionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell: TTCTransactionInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! TTCTransactionInfoTableViewCell
            
            cell.setData(d: order)
            
            return cell
        default:
            let cell: TTCTransactionValueTableViewCell = tableView.dequeueReusableCell(withIdentifier: "valueCell", for: indexPath) as! TTCTransactionValueTableViewCell
            
            switch indexPath.row {
            case 1:
                cell.titleLabel.text = "Order Number"
                cell.descriptionLabel.text = order?.outTradeNo
            case 2:
                cell.titleLabel.text = "Company"
                cell.descriptionLabel.text = order?.partnerName
            case 3:
                cell.titleLabel.text = "Order Info"
                cell.descriptionLabel.text = order?.description_p
            default:
                break
            }
            return cell
        }
    }
}

// MARK: - Delegate
extension TTCTransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 120
        default:
            return 64
        }
    }
}

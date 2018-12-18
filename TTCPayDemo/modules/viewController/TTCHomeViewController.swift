//
//  ViewController.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/11.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

struct TTCGoods {
    
    var name = ""
    var imageName = ""
    var description = ""
    var price = 0
    
    var image: UIImage? {
        get {
            return UIImage(named: self.imageName)
        }
    }
    
}

class TTCHomeViewController: TTCBaseViewController {

    var datas: [TTCGoods] {
        get {
            return [
            TTCGoods(name: "Mellow", imageName: "1", description: "Get Harmonious Moment", price: 10500),
            TTCGoods(name: "Shell", imageName: "2", description: "Elegant Curve Creator", price: 8500),
            TTCGoods(name: "Designer Chair", imageName: "3", description: "Elegant Curve Creator", price: 7500),
            TTCGoods(name: "Industrial", imageName: "4", description: "Elegant Curve Creator", price: 1699),
            TTCGoods(name: "Belong", imageName: "5", description: "Elegant Curve Creator", price: 3499),
            TTCGoods(name: "Blu dot", imageName: "6", description: "Puff Puff Studio Sofa", price: 2899),
            TTCGoods(name: "Beetle", imageName: "7", description: "GamFratesi for Gobi", price: 6999),
            TTCGoods(name: "CH162", imageName: "8", description: "Hans J. Wegner from Carl Hansen & Son", price: 1299)]
        }
    }
    
    var shopCarts: [TTCGoods] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.titleView = titleView
        self.title = "Furinture"
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shopCarts.isEmpty {
            cartLabel.backgroundColor = UIColor.clear
            cartLabel.text = ""
        } else {
            cartLabel.backgroundColor = UIColor.appRed
            cartLabel.text = "\(shopCarts.count)"
        }
    }
    
    // MARK: - lazy
    
    lazy var titleView: UIView = {
        
        let view: UIView = UIView()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        
        let label = UILabel()
        label.font = UIFont.appBoldFont(34)
        label.textColor = UIColor.appBlack
        label.frame = CGRect(x: 20, y: 0, width: 200, height: 44)
        label.text = "Furinture"
        view.addSubview(label)
        
        view.addSubview(cartLabel)
        
        let button = UIButton()
        button.frame = CGRect(x: screenWidth-20-44, y: 0, width: 44, height: 44)
        button.setImage(UIImage(named: "cart"), for: .normal)
        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        view.addSubview(button)
        
        return view
    }()
    
    lazy var cartLabel: UILabel = {
        
        let label = UILabel()
        label.frame = CGRect(x: screenWidth-27-20, y: 0, width: 16, height: 16)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.appBoldFont(12)
        label.textAlignment = .center
        label.textColor = UIColor.appWhite
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/7))
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        tableView.register(TTCHomeTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.appWhite
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 91)
        imageView.image = UIImage(named: "Bitmap")
        tableView.tableHeaderView = imageView
        
        return tableView
    }()
}

// MARK: - common
extension TTCHomeViewController {
    
    func addCarts(data: TTCGoods) {
        if !shopCarts.contains(where: { (item) -> Bool in
            if item.name == data.name {
                return true
            }
            return false
        }) {
            shopCarts.append(data)
        }
        
        if shopCarts.isEmpty {
            cartLabel.backgroundColor = UIColor.clear
            cartLabel.text = ""
        } else {
            cartLabel.backgroundColor = UIColor.appRed
            cartLabel.text = "\(shopCarts.count)"
        }
    }
}

// MARK: - action
extension TTCHomeViewController {
    
    @objc func rightClick() {
        
        let cart = TTCShoppingCartViewController()
        cart.shopCarts = shopCarts
        
        cart.removeBlock = { [weak self] data in
            self?.shopCarts.removeAll(where: { (item) -> Bool in
                if item.name == data.name {
                    return true
                }
                return false
            })
        }
        
        self.navigationController?.pushViewController(cart, animated: true)
    }
}

// MARK: - DataSource
extension TTCHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TTCHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TTCHomeTableViewCell
        
        cell.setData(data: datas[indexPath.row])
        
        cell.addCartBlock = { [weak self] data in
            self?.addCarts(data: data)
        }
        
        return cell
    }
}

// MARK: - Delegate
extension TTCHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        self.addCarts(data: data)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 260
    }
}


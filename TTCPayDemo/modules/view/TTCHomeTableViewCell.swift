//
//  TTCHomeTableViewCell.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/12.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

class TTCHomeTableViewCell: UITableViewCell {

    var addCartBlock: ((TTCGoods) -> Void)?
    var data: TTCGoods?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.layer.masksToBounds = false
        self.layer.masksToBounds = false
        contentView.addSubview(backgroundShadowView)
        contentView.addSubview(backgroundWhiteView)
        backgroundWhiteView.addSubview(pictureImage)
        backgroundWhiteView.addSubview(nameLabel)
        backgroundWhiteView.addSubview(descriptionLabel)
        backgroundWhiteView.addSubview(addButton)
        backgroundWhiteView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: TTCGoods) {
        self.data = data
        
        pictureImage.image = data.image
        nameLabel.text = data.name
        descriptionLabel.text = data.description
        addButton.setTitle("$\(data.price.description)", for: .normal)
    }
    
    // MARK: - action
    
    @objc func addClick() {
        if let d = data {
            addCartBlock?(d)
        }
    }
    
    // MARK: - LAZY
    lazy var backgroundShadowView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.appWhite
        view.frame = CGRect(x: 20, y: 10, width: screenWidth-40, height: 240)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.appShadowGrayColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = 10
        
        return view
    }()
    
    lazy var backgroundWhiteView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.appWhite
        view.frame = CGRect(x: 20, y: 10, width: screenWidth-40, height: 240)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var pictureImage: UIImageView = {
        
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth-40, height: 162)
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appBlack
        view.font = UIFont.appBoldFont(18)
        view.frame = CGRect(x: 20, y: 20+162, width: 200, height: 18)
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appGray
        view.font = UIFont.appBoldFont(14)
        view.frame = CGRect(x: 20, y: 41+162, width: 250, height: 16)
        
        return view
    }()
    
    lazy var addButton: UIButton = {
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "addCart"), for: .normal)
        addButton.frame = CGRect(x: screenWidth-100-40-20, y: 10+162, width: 100, height: 40)
        addButton.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        addButton.titleLabel?.font = UIFont.appBoldFont(14)
        addButton.setTitleColor(UIColor.appBlack, for: .normal)
        addButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: -30)
        addButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        return addButton
    }()
    
    lazy var line: UIImageView = {
        
        let line = UIImageView()
        line.image = UIImage(named: "line")
        line.frame = CGRect(x: 0, y: 162, width: screenWidth-40, height: 1)
        
        return line
    }()
}

//
//  TTCShopCartTableViewCell.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/12.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

class TTCShopCartTableViewCell: UITableViewCell {

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
        backgroundWhiteView.addSubview(priceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func setData(data: TTCGoods) {
        self.data = data
        
        pictureImage.image = data.image
        nameLabel.text = data.name
        descriptionLabel.text = data.description
        priceLabel.text = "$\(data.price)"
    }
    
    // MARK: - LAZY
    lazy var backgroundShadowView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.appWhite
        view.frame = CGRect(x: 20, y: 10, width: screenWidth-40, height: 96)
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
        view.frame = CGRect(x: 20, y: 10, width: screenWidth-40, height: 96)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var pictureImage: UIImageView = {
        
        let view = UIImageView()
        view.frame = CGRect(x: 17, y: 24, width: 108, height: 44)
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appBlack
        view.font = UIFont.appBoldFont(18)
        view.frame = CGRect(x: 142, y: 20, width: 150, height: 18)
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appGray
        view.font = UIFont.appBoldFont(14)
        view.frame = CGRect(x: 142, y: 41, width: 170, height: 16)
        
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appRed
        view.font = UIFont.appFont(14)
        view.frame = CGRect(x: 142, y: 64, width: 150, height: 14)
        
        return view
    }()
}

//
//  TTCCheckoutTableViewCell.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/13.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit

class TTCCheckoutTableViewCell: UITableViewCell {

    var payment: TTCPayment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.addSubview(selectView)
        } else {
            selectView.removeFromSuperview()
        }
        
        switch payment?.name {
        case "TTC Pay":
            selectView.backgroundColor = UIColor.appBlue
//        case "Mastercard":
//            selectView.backgroundColor = UIColor.appGray
        default:
            selectView.backgroundColor = UIColor.appWhite
        }
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: TTCPayment) {
        payment = data
        
        nameLabel.text = payment?.name
        pictureImage.image = payment?.image
        selectView.image = payment?.selectImage
    }
    
    // MARK: - LAZY
    
    lazy var selectView: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = UIView.ContentMode.center
        view.frame = CGRect(x: 20, y: 10, width: screenWidth-40, height: 96)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
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
        view.frame = CGRect(x: 20, y: 18, width: 57, height: 60)
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appBlack
        view.font = UIFont.appBoldFont(18)
        view.frame = CGRect(x: 97, y: 40, width: 150, height: 18)
        
        return view
    }()
    
}

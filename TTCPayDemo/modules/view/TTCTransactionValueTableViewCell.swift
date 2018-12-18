//
//  TTCTransactionValueTableViewCell.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/13.
//  Copyright © 2018 chenchao. All rights reserved.
//


import UIKit
import BigInt

class TTCTransactionValueTableViewCell: UITableViewCell {

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
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LAZY
    
    lazy var titleLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appBlack
        view.font = UIFont.appFont(12)
        view.frame = CGRect(x: 20, y: 15, width: screenWidth-40, height: 14)
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appBlack
        view.font = UIFont.appBoldFont(14)
        view.numberOfLines = 0
        view.frame = CGRect(x: 20, y: 33, width: screenWidth-40, height: 16)
        
        return view
    }()
    
    lazy var line: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.appLightGray
        view.frame = CGRect(x: 20, y: 63, width: screenWidth-40, height: 1)
        
        return view
    }()
}

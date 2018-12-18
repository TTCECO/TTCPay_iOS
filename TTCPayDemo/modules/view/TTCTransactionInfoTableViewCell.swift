//
//  TTCTransactionInfoTableViewCell.swift
//  TTCPayDemo
//
//  Created by chenchao on 2018/12/13.
//  Copyright © 2018 chenchao. All rights reserved.
//

import UIKit
import TTCPay
import BigInt

class TTCTransactionInfoTableViewCell: UITableViewCell {
    
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
        addSubview(infoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(d: TTCOrder?) {
        
        guard let data = d else {
            return
        }
        
        switch data.state {
        case 2:
            titleLabel.text = "Confirmation..."
            titleLabel.textColor = UIColor.appBlack
        case 3:
            titleLabel.text = "Success"
            titleLabel.textColor = UIColor.appGreen
        case 4, 5:
            titleLabel.text = "Failed"
            titleLabel.textColor = UIColor.appRed
        default:
            titleLabel.text = ""
            titleLabel.textColor = UIColor.appBlack
        }
        
        if let totalBig = BigInt(data.totalFee) {
            let total = EtherNumberFormatter.shared.short().bigIntToNumberString(from: totalBig)
            infoLabel.text = "Amount: \(total) TTC"
        }
    }
    
    // MARK: - LAZY
    
    lazy var titleLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appBlack
        view.font = UIFont.appFont(34)
        view.textAlignment = NSTextAlignment.center
        view.frame = CGRect(x: 0, y: 28, width: screenWidth, height: 40)
        
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.appBlack
        view.font = UIFont.appBoldFont(18)
        view.textAlignment = NSTextAlignment.center
        view.frame = CGRect(x: 0, y: 68, width: screenWidth, height: 24)
        
        return view
    }()
    
}

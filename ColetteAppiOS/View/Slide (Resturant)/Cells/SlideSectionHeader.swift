//
//  SlideSectionHeader.swift
//  SallaCustomerAppIOS
//
//  Created by PogMac on 06/09/2020.
//  Copyright © 2020 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

class CurrencySectionHeader: UICollectionViewCell {
    
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColors.Default
        label.font = UIFonts.fontBySize(type: .bold,size: 18)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.layoutToSuperview(.centerY)
        label.layoutToSuperview(.width, offset: -20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

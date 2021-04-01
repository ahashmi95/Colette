//
//  SeperatorResturant.swift
//  SallaCustomerAppIOS
//
//  Created by PogMac on 06/09/2020.
//  Copyright © 2020 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

class SepraterResturantCell: UICollectionViewCell {
    
    lazy var seperator:SeparateLine = {
        let view = SeparateLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(seperator)
        seperator.layoutToSuperview(.centerY,.width)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

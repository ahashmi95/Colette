//
//  EmptyResultsCell.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 05/05/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import UIKit

class EmptyResultsCell: UICollectionViewCell {
    

    @IBOutlet weak var contantLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    func setup() {
        self.contantLbl.font = UIFonts.fontBySize(size: 23)
        self.contantLbl.textColor = UIColor.init(hex: 0x999999)
        self.contantLbl.text = UIMessage.EMPTY_SEARCH
    }

}

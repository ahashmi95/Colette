//
//  HistoryCell.swift
//  SearchAutoComplete
//
//  Created by Amin Fadul on 23/04/2019.
//  Copyright © 2019 AF. All rights reserved.
//

import Foundation
import UIKit

class HistoryCell: UICollectionViewCell {

    @IBOutlet weak var searchLbl: UILabel!

    @IBOutlet weak var searchIcon: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }

    private func setupViews() {
        self.searchLbl.font = UIFonts.fontBySize(size: 14)
        self.searchLbl.textColor = UIColor(hex: 0xffbbbbbb)

        self.searchIcon.font = UIFont(name: "sallaicons", size: 14)
        self.searchIcon.textColor = UIColor(hex: 0xffbbbbbb)

    }
}

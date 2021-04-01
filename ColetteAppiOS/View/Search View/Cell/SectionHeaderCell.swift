//
//  SectionHeaderCell.swift
//  SearchAutoComplete
//
//  Created by Amin Fadul on 23/04/2019.
//  Copyright © 2019 AF. All rights reserved.
//

import Foundation
import UIKit

class SectionHeaderCell: UICollectionViewCell {

    var onClick: (() -> Void)?

    @IBOutlet weak var spraterView: UIView!

    @IBOutlet weak var searchLbl: UILabel!

    @IBOutlet weak var deleteBtn: UIButton!

    @IBAction func onAction(_ sender: UIButton) {
        onClick!()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    func setup() {

        self.searchLbl.font = UIFonts.fontBySize(size: 16)
        self.searchLbl.textColor = UIColor.init(hex: 0x999999)

        self.deleteBtn.titleLabel?.font = UIFonts.fontBySize(size: 16)
        self.deleteBtn.setTitle(UIMessage.DELETE, for: .normal)
        self.deleteBtn.setTitleColor(UIColor.red, for: .normal)

        self.spraterView.backgroundColor = UIColor.init(hex: 0xffeeeeee)

    }
    
    func hideSeperator(state: Bool){
        self.spraterView.isHidden = state
    }

}

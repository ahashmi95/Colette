//
//  AuthButton.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 29/09/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.backgroundColor = AppDM.shared.colorMainDark ?? UIColor.init(hex: 0xf8f8f8)
        self.setTitleColor(AppDM.shared.authTextColor ?? .white, for: .normal)
        self.titleLabel?.font = UIFonts.fontBySize(size: 16)
    }

    func dissable() {
        self.backgroundColor = .gray
        self.setTitleColor(.white, for: .normal)
        self.layer.borderColor = UIColor.gray.cgColor
        self.isUserInteractionEnabled = false
    }

    func enable() {
        self.backgroundColor = AppDM.shared.colorMainDark ?? UIColor.init(hex: 0xf8f8f8)
        self.setTitleColor(AppDM.shared.authTextColor ?? .white, for: .normal)
        self.isUserInteractionEnabled = true
    }
    
    func setupResturant(){
        self.layer.cornerRadius = UI.REST_MAIN_RADIOS
    }
}

class AddtoCart: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.backgroundColor = AppDM.shared.colorMainDark ?? UIColor.init(hex: 0xf8f8f8)
        self.setTitleColor(AppDM.shared.authTextColor ?? .white, for: .normal)
        self.titleLabel?.font = UIFonts.fontBySize(size: 14)
    }
    
    func dissable() {
        isUserInteractionEnabled = false
        backgroundColor = UIColors.LighterBorder
        setTitle(UIMessage.NO_AMOUNT, for: .normal)
        setTitleColor(UIColors.Dimmed, for: .normal)
    }
    
    func enable() {
        isUserInteractionEnabled = true
        backgroundColor = AppDM.shared.colorMainDark ?? UIColor.init(hex: 0xf8f8f8)
        setTitle(UIMessage.ADD_TO_CART, for: .normal)
        setTitleColor(AppDM.shared.authTextColor ?? .white, for: .normal)
    }
}

class AddtoCartType1: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        //self.layer.borderWidth = 1
        //self.layer.borderColor = AppDM.shared.authColor?.cgColor ?? UIColor.white.cgColor
        self.backgroundColor = AppDM.shared.orignalAppColor ?? UIColor.init(hex: 0xf8f8f8)
        self.setTitleColor(AppDM.shared.authTextColor ?? .white, for: .normal)
        layer.maskedCorners = [.layerMaxXMinYCorner]
        //layerMinXMinYCorner
        layer.cornerRadius = UI.RADIOS
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        clipsToBounds = true
        //
    }
    
    func dissable() {
        isUserInteractionEnabled = false
        backgroundColor = UIColors.LighterBorder
        setTitle(UIMessage.NO_AMOUNT, for: .normal)
        setTitleColor(UIColors.Default, for: .normal)
        self.titleLabel?.font = UIFonts.fontBySize(size: 12)
    }
    
    func enable() {
        isUserInteractionEnabled = true
        backgroundColor = AppDM.shared.colorMainDark ?? UIColor.init(hex: 0xf8f8f8)
        setTitle(String(format: "%C", 0xea6e), for: .normal)
        setTitleColor(AppDM.shared.authTextColor ?? .white, for: .normal)
        self.titleLabel?.font = UIFonts.fontIcon(font: .sallaIcons, size: 18)
    }
}

class LinkButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.titleLabel?.textAlignment = .right
    }

    func setupTitle(title: String) {
     setAttributedTitle(NSAttributedString(string: title, attributes:
        [
         .underlineStyle: NSUnderlineStyle.single.rawValue,
         .font: UIFonts.fontBySize(size: 16),
         .foregroundColor: UIColor.systemBlue
        ]
      ), for: .normal)
    }
}

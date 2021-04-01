//
//  OtpAuthTextField.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 29/09/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

class OtpAuthTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.clearButtonMode = .unlessEditing
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.textAlignment = .left
        self.backgroundColor = UIColor(hex: 0xf8f8f8)
        self.textColor = UIColor(hex: 0x000000)
        self.font = UIFont(name: AppDataManger.shared.fontFamilyRegular!, size: 19)
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.rightViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.leftViewMode = .always
    }
}

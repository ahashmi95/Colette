//
//  AuthTextField.swift
//  SallaCustomerAppIOS
//
//  Created by Muhammad Fatani on 16/04/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import UIKit

class AuthTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 40)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    init(frame: CGRect, _ icon: Int? = nil) {
        super.init(frame: frame)
        setup(icon)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup(_ icon: Int?) {

        if let icon = icon {
            let iconView = UILabel()
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.font = UIFont(name: "sallaicons", size: 20)
            iconView.text = String(format: "%C", icon)
            iconView.textColor = UIColor.gray
            iconView.textAlignment = .center

            let spreater = UIView()
            spreater.translatesAutoresizingMaskIntoConstraints = false
            spreater.backgroundColor = .gray

            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            rightView.backgroundColor = .clear
            rightView.addSubview(iconView)
            rightView.addSubview(spreater)

            NSLayoutConstraint.activate([
                iconView.centerXAnchor.constraint(equalTo: rightView.centerXAnchor),
                iconView.centerYAnchor.constraint(equalTo: rightView.centerYAnchor),
                iconView.heightAnchor.constraint(equalToConstant: 20),
                iconView.widthAnchor.constraint(equalToConstant: 20),

                spreater.topAnchor.constraint(equalTo: rightView.topAnchor, constant: 5),
                spreater.bottomAnchor.constraint(equalTo: rightView.bottomAnchor, constant: -5),
                spreater.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -5),
                spreater.widthAnchor.constraint(equalToConstant: 1)
            ])

            self.rightView = rightView
            self.rightViewMode = .always
        } else {
            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
            self.rightViewMode = .always
        }

        //self.clearButtonMode = .unlessEditing
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.textAlignment = .left
        self.backgroundColor = UIColor(hex: 0xf8f8f8)
        self.textColor = UIColor(hex: 0x000000)
        self.font = UIFonts.fontBySize(size: 17)
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.leftViewMode = .always
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 30, y: 0, width: 26, height: bounds.height)
    }
}

class SearchTextField: UITextField {

    var onShowSku: (() -> Void)?
    
    lazy var skuLeftView: UIView = {
        let paddingLeftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 110, height: 80))
        let arrowIcon = UILabel()
        arrowIcon.isUserInteractionEnabled = true
        arrowIcon.font = UIFonts.fontIcon(font: .sallaIcons, size: 18)
        arrowIcon.text = 0xED57.iconCode()
        arrowIcon.textColor = UIColors.Default
        paddingLeftView.addSubview(arrowIcon)
        arrowIcon.layout(.topMargin, .bottomMargin, to: paddingLeftView)
        arrowIcon.layout(.leadingMargin, to: paddingLeftView, offset: 10)
        arrowIcon.layout(.trailing, to: paddingLeftView, offset: -10)
        paddingLeftView.isUserInteractionEnabled = true

        return paddingLeftView
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        semanticContentAttribute = .forceLeftToRight
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup(placeholder: String, hostBg: Int) {

        backgroundColor = .white
        let attributedPlaceholder =  NSAttributedString(string: placeholder, attributes: [
            NSAttributedString.Key.font: UIFonts.fontBySize()
            ])

        self.attributedPlaceholder = attributedPlaceholder

        self.font = UIFonts.fontBySize()

        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.rightViewMode = .always

        self.delegate = delegate
        self.returnKeyType = .search
        self.textAlignment = .right
        self.layer.cornerRadius = CGFloat(4)
        self.layer.masksToBounds = false
        self.layer.borderColor = hostBg == 0xffffffff ? UIColor.gray.cgColor : UIColor.red.cgColor
        self.layer.borderWidth = hostBg == 0xffffffff ? 1.0 : 0.0
    }
    
    func dissableBorder() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = CGFloat(10)
    }
    
    func addSkuBtn() {
        self.leftViewMode = .always
        self.leftView = skuLeftView
    }
    
    @objc func showSkuSearch(){
        onShowSku?()
    }

}

//class BrandSearchTextField: UITextField {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    func setup(placeholder: String, hostBg: Int) {
//
//        backgroundColor = .white
//        let attributedPlaceholder =  NSAttributedString(string: placeholder, attributes: [
//            NSAttributedString.Key.font: UIFonts.fontBySize()
//            ])
//
//        self.attributedPlaceholder = attributedPlaceholder
//
//        self.font = UIFonts.fontBySize()
//
//        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
//        self.rightViewMode = .always
//
//        self.delegate = delegate
//        self.returnKeyType = .search
//        self.textAlignment = .right
//        self.layer.cornerRadius = CGFloat(4)
//        self.layer.masksToBounds = false
//        
//    }
//
//}

class OtpTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {

        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.textAlignment = .left
        self.backgroundColor = UIColor(hex: 0xf8f8f8)
        self.textColor = UIColor(hex: 0x000000)
        self.textAlignment = .center
            self.keyboardType = .asciiCapableNumberPad
        self.font = UIFonts.fontBySize(size: 19)

        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.rightViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.leftViewMode = .always
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 30, y: 0, width: 10, height: bounds.height)
    }

}


class AuthTextFieldPlain: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

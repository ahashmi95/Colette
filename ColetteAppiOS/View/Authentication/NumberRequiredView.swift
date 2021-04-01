//
//  NumberRequiredView.swift
//  SallaCustomerAppIOS
//
//  Created by Abdulrahman A. Hashmi on 24/01/2021.
//  Copyright © 2021 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit
import libPhoneNumber_iOS
import IQKeyboardManagerSwift


class NumberRequiredView: UIView, FPNTextFieldDelegate {
    
    private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
    
    internal var argOnExit: (() -> Void)?
    internal var argOnSubmit: ((_ isValid: Bool ,_ countryCode:String,_ code: String,_ phone: String) -> Void)?
    var onSubmitOtp:((_ code: String?,_ countryCode: String?,_ phone: String?) -> Void)?

    var isVaild: Bool = false {
        didSet {
            self.btnSubmit.isEnabled = isVaild
            self.btnSubmit.backgroundColor = isVaild ? AppDM.shared.mainColor : UIColors.Disabled
        }
    }
    
    var countryCode: String = "SA"
    var dialCode: String = "+966"
    
    private let containerPopup: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblTitle: PaddingLabel = {
        let view =  PaddingLabel(top: 8, bottom: 4, left: 18, right: 18)
        view.backgroundColor = AppDM.shared.mainColor
        view.text = "تسجيل رقم الجوال"
        view.textColor = AppDM.shared.authTextColor
        view.textAlignment = .right
        view.font = UIFonts.fontBySize(type: .regular,size: 18.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let lblSubTitle: PaddingLabel = {
        let view =  PaddingLabel(top: 5, bottom: 12, left: 18, right: 18)
        view.backgroundColor = AppDM.shared.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = AppDM.shared.authTextColor
        view.textAlignment = .right
        view.font = UIFonts.fontBySize(type: .regular,size: 14.0)
        view.text = "الرجاء إدخال رقم الجوال لإكمال تسجيل الدخول"
        return view
    }()
    
    private lazy var textInputsStack:UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var tfMobile: FPNTextField = {
        let view = FPNTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFonts.fontBySize(size:  14.0)
        view.hasPhoneNumberExample = true
        view.setFlag(for: FPNCountryCode(rawValue: "SA")!)
        view.textColor = UIColor.black
        view.textContentType = UITextContentType.telephoneNumber
        let placeholder = UIMessage.MOBILE_PHONE
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColors.LighterBorder.cgColor
        view.semanticContentAttribute = .forceLeftToRight
        view.textAlignment = .left
        return view
    }()
    
    private lazy var otp1Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 1
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.set(.height, of: 45)
        txt.isEnabled = false
        return txt
    }()
    
    private lazy var otp2Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 2
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.set(.height, of: 45)
        txt.isEnabled = false
        return txt
    }()
    
    private lazy var otp3Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 3
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.set(.height, of: 45)
        txt.isEnabled = false
        return txt
    }()
    
    private lazy var otp4Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 4
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.set(.height, of: 45)
        txt.isEnabled = false
        return txt
    }()
    
    private lazy var otpStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    private let btnSubmit: UIButton = {
        let view = UIButton()
        view.backgroundColor = AppDM.shared.mainColor
        view.setTitle("إرسال كود التحقق", for: .normal)
        view.titleLabel?.font = UIFonts.fontBySize(type: .regular,size: 16.0)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = UI.RADIOS
        view.setTitleColor(AppDM.shared.authTextColor, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnClose: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColors.LIGHT_GRAY
        view.setTitle(0xEA47.iconCode(), for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font =  UIFont(name: "sallaicons", size: 22)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        otp1Txtfeild.delegate = self
        otp2Txtfeild.delegate = self
        otp3Txtfeild.delegate = self
        otp4Txtfeild.delegate = self
        
        otp1Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp2Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp3Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp4Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                
        addSubview(containerPopup)
        addSubview(btnClose)
        containerPopup.layoutToSuperview(.centerX,.centerY)
        containerPopup.layoutToSuperview(.width, ratio: 0.85)
        containerPopup.applyMaxWidth()
        
        otpStack.addArrangedSubview(otp1Txtfeild)
        otpStack.addArrangedSubview(otp2Txtfeild)
        otpStack.addArrangedSubview(otp3Txtfeild)
        otpStack.addArrangedSubview(otp4Txtfeild)
        
        
        textInputsStack.addArrangedSubview(tfMobile)
        textInputsStack.addArrangedSubview(otpStack)
        containerPopup.addSubview(lblTitle)
        containerPopup.addSubview(lblSubTitle)
        containerPopup.addSubview(textInputsStack)
        containerPopup.addSubview(btnSubmit)
        
        lblTitle.layout(.leading, .trailing, .top, to: containerPopup)
        lblSubTitle.layout(.leading, .trailing, to: containerPopup)
        lblSubTitle.layout(.top, to: .bottom, of: lblTitle)
        
        textInputsStack.layout(.top, to: .bottom, of: lblSubTitle, offset: 15)
        textInputsStack.layout(.leading, to: containerPopup, offset: 10)
        textInputsStack.layout(.trailing, to: containerPopup, offset: -10)
        
        btnSubmit.layout(.top, to: .bottom, of: textInputsStack, offset: 15)
        btnSubmit.layout(.bottom, to: .bottom, of: containerPopup, offset: -15)
        btnSubmit.layout(.leading, to: containerPopup, offset: 10)
        btnSubmit.layout(.trailing, to: containerPopup, offset: -10)
        btnSubmit.set(.height, of: 45)
        
        btnClose.set(.height, .width, of: 40)
        btnClose.layout(.top, to: .bottom, of: containerPopup, offset: 20)
        btnClose.layoutToSuperview(.centerX)
        
        tfMobile.delegate = self
        tfMobile.applyMaxWidth()
        tfMobile.set(.height, of: 45)
                
        btnSubmit.addTarget(self, action: #selector(onBtnSubmit), for: .touchDown)
        btnClose.addTarget(self, action: #selector(onBtnClose), for: .touchDown)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal func setup() {
        if let theCountry = AppDM.shared.user?.phoneCode,
           let theFpnCountry = FPNCountryCode(rawValue: theCountry){
            self.tfMobile.setFlag(for: theFpnCountry)
        }
        
        if let theMobile = AppDM.shared.user?.phoneNumber {
            self.tfMobile.set(phoneNumber: theMobile.description)
        }
    }
    
    internal func setupParentView(viewController: UIViewController) {
        self.tfMobile.parentViewController = viewController
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        self.dialCode = dialCode
        self.countryCode = code
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.undoManager?.disableUndoRegistration()
        
        guard let text = textField.text else {return}
        textField.text = text.english
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        let v = UIImageView()
        v.image = isValid ? #imageLiteral(resourceName: "success") : UIImage(imageLiteralResourceName: "fail")
        v.alpha = isValid ? 1 : 0.5
        v.contentMode = .scaleAspectFit
        view.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            v.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            v.heightAnchor.constraint(equalToConstant: 18),
            v.widthAnchor.constraint(equalToConstant: 18)
        ])

        textField.rightViewMode = .always
        textField.rightView = view
        
        isVaild = isValid
    }
    
    @objc private func onBtnSubmit() {
        
        if let thePhoneNumber = tfMobile.getRawPhoneNumber(),
           let theCode = tfMobile.selectedCountry?.code.rawValue {
            argOnSubmit?(isVaild,self.countryCode,theCode ,thePhoneNumber)
        } else {
            // Submit empty for to show error
            argOnSubmit?(isVaild,"","" ,"")
        }
    }
    
    private func submitOtp(otp: String ) {
        onSubmitOtp?(otp,self.countryCode,tfMobile.getRawPhoneNumber())
    }
    
    @objc private func onBtnClose() {
        argOnExit?()
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField != tfMobile {
            
        let text = textField.text
        
        if  text?.count == 1 {
            switch textField {
            case otp1Txtfeild:
                otp2Txtfeild.becomeFirstResponder()
            case otp2Txtfeild:
                otp3Txtfeild.becomeFirstResponder()
            case otp3Txtfeild:
                otp4Txtfeild.becomeFirstResponder()
            case otp4Txtfeild:
                otp4Txtfeild.resignFirstResponder()
            default:
                break
            }
        }
        if text?.count == 0 {
            switch textField {
            case otp1Txtfeild:
                otp1Txtfeild.becomeFirstResponder()
            case otp2Txtfeild:
                otp1Txtfeild.becomeFirstResponder()
            case otp3Txtfeild:
                otp2Txtfeild.becomeFirstResponder()
            case otp4Txtfeild:
                otp3Txtfeild.becomeFirstResponder()
            default:
                break
            }
        }
        
        if #available(iOS 12.0, *) {
            if textField.textContentType == UITextContentType.oneTimeCode {
                if let otpCode = textField.text, otpCode.count > 3 {
                    otp1Txtfeild.text = String(otpCode[otpCode.startIndex])
                    otp2Txtfeild.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 1)])
                    otp3Txtfeild.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 2)])
                    otp4Txtfeild.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 3)])
                }
            }
        }
        
        if let otp = assmbleCode() {
            if otp.count > 3 {
                self.submitOtp(otp: otp)
            }
        }
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != tfMobile {
            let char = string.cString(using: String.Encoding.utf8)
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
            
            if textField.text!.count == 1 {
                return false
            }
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != tfMobile {
            textField.text = ""
        }
    }
    
    func assmbleCode() -> String? {
        guard let otp1 = otp1Txtfeild.text,
              let otp2 = otp2Txtfeild.text,
              let otp3 = otp3Txtfeild.text,
              let otp4 = otp4Txtfeild.text else {
            return nil
        }
        return "\(otp1)\(otp2)\(otp3)\(otp4)"
    }
    
    func toggleKeyboard() {
        self.otp1Txtfeild.becomeFirstResponder()
    }
    
    func toggleOtp(state: Bool) {
        otp1Txtfeild.isEnabled = state
        otp2Txtfeild.isEnabled = state
        otp3Txtfeild.isEnabled = state
        otp4Txtfeild.isEnabled = state
    }
    
    func clear() {
        otp1Txtfeild.text = nil
        otp2Txtfeild.text = nil
        otp3Txtfeild.text = nil
        otp4Txtfeild.text = nil
    }
    
    func toogleStatus(status: Bool) {
        self.btnSubmit.isEnabled = status
        self.btnSubmit.backgroundColor = status ? AppDM.shared.mainColor : UIColors.Disabled
    }
}

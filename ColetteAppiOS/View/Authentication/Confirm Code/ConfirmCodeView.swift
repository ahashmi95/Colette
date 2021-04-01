//
//  ConfirmCodeView.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 29/09/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class ConfirmCodeView: UIView, UITextFieldDelegate {

    var onResendEmail:(() -> Void)?
    var onResendMobile:(() -> Void)?
    var onResendVoice:(() -> Void)?

    var onSubmit:((_ code: String?) -> Void)?

    private lazy var confirmCodeCaption: UILabel = {
      let lbl = UILabel()
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.font = UIFonts.fontBySize(size: 18.0)
      lbl.textAlignment = .center
      lbl.numberOfLines = 0
      lbl.textColor = UIColors.Default
      return lbl
    }()

    private lazy var otp1Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 1
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    private lazy var otp2Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 2
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    private lazy var otp3Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 3
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    private lazy var otp4Txtfeild: OtpTextField = {
        let txt = OtpTextField()
        txt.tag = 4
        txt.translatesAutoresizingMaskIntoConstraints = false
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

    private lazy var verfiyButton: AuthButton = {
        let btn = AuthButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(UIMessage.CHECK_BTN, for: .normal)
        btn.addTarget(self, action: #selector(handleSubmit), for: .touchDown)
        return btn
    }()

    private lazy var spreater: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColors.Background
        return view
    }()

    private lazy var timerCaption: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFonts.fontBySize(size: 18.0)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.textColor = UIColors.BLACK_AUTH
        lbl.text = String(format: UIMessage.RESEND_SPREATAR, 30)
        return lbl
    }()

    let resendByMobileBtn: ShapedBtn = {
        let btn = ShapedBtn(
            frame: .zero,
            iconCode: 0xece4,
            text: UIMessage.TEXT_RESEND_BTN,
            isFillBG: false)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let resendByVoiceBtn: ShapedBtn = {
        let btn = ShapedBtn(
            frame: .zero,
            iconCode: 0xee40,
            text: UIMessage.VOICE_RESEND_BTN,
            isFillBG: false)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let resendByEmailBtn: ShapedBtn = {
        let btn = ShapedBtn(
            frame: .zero,
            iconCode: 0xed57,
            text: UIMessage.EMAIL_RESEND_BTN,
            isFillBG: false)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var resendStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()

    init(frame: CGRect, view authType: AuthType, userinfo: String) {
        super.init(frame: frame)

        addSubview(confirmCodeCaption)
        addSubview(otpStack)
        addSubview(verfiyButton)
        addSubview(timerCaption)
        addSubview(resendStack)

        otpStack.addArrangedSubview(otp1Txtfeild)
        otpStack.addArrangedSubview(otp2Txtfeild)
        otpStack.addArrangedSubview(otp3Txtfeild)
        otpStack.addArrangedSubview(otp4Txtfeild)

        otp1Txtfeild.delegate = self
        otp2Txtfeild.delegate = self
        otp3Txtfeild.delegate = self
        otp4Txtfeild.delegate = self

        otp1Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp2Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp3Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp4Txtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)

        switch authType {
        case .email:
            confirmCodeCaption.text = String(format: UIMessage.CONFIRM_CODE_CAPTION_E, userinfo)
            resendStack.addArrangedSubview(resendByEmailBtn)
            resendStack.widthAnchor.constraint(equalToConstant: 100).isActive = true
        case .mobile:
            confirmCodeCaption.text = String(format: UIMessage.CONFIRM_CODE_CAPTION_M, userinfo)
            resendStack.addArrangedSubview(resendByVoiceBtn)
            resendStack.addArrangedSubview(resendByMobileBtn)
            resendStack.widthAnchor.constraint(equalToConstant: 280).isActive = true
        }

        NSLayoutConstraint.activate([
            confirmCodeCaption.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmCodeCaption.topAnchor.constraint(equalTo: topAnchor, constant: 75),
            confirmCodeCaption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            confirmCodeCaption.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            confirmCodeCaption.heightAnchor.constraint(equalToConstant: 80),

            otpStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            otpStack.topAnchor.constraint(equalTo: confirmCodeCaption.bottomAnchor, constant: 20),
            otpStack.heightAnchor.constraint(equalToConstant: 50),
            otpStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            otpStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            verfiyButton.heightAnchor.constraint(equalToConstant: 50),
            verfiyButton.topAnchor.constraint(equalTo: otpStack.bottomAnchor, constant: 20),
            verfiyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            verfiyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            verfiyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            timerCaption.heightAnchor.constraint(equalToConstant: 30),
            timerCaption.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerCaption.trailingAnchor.constraint(equalTo: trailingAnchor),
            timerCaption.topAnchor.constraint(equalTo: verfiyButton.bottomAnchor, constant: 20),

            resendStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            resendStack.topAnchor.constraint(equalTo: timerCaption.bottomAnchor, constant: 20),
            resendStack.heightAnchor.constraint(equalToConstant: 40)

        ])

        resendByVoiceBtn.onClick = { [weak self] in
            guard let self = self else {return}
            self.onResendVoice?()
        }

        resendByEmailBtn.onClick = { [weak self] in
            guard let self = self else {return}
            self.onResendEmail?()
        }

        resendByMobileBtn.onClick = { [weak self] in
            guard let self = self else {return}
            self.onResendMobile?()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func textFieldDidChange(textField: UITextField) {
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
                onSubmit?(otp)
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
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

    func updateTimer(time: String) {
        self.timerCaption.text = time
    }

    func toogleStatus(status: Bool) {
        self.resendByEmailBtn.isActive = status
        self.resendByVoiceBtn.isActive = status
        self.resendByMobileBtn.isActive = status
    }

    @objc func handleSubmit() {
        onSubmit?(assmbleCode())
    }

    func toggleKeyboard() {
        self.otp1Txtfeild.becomeFirstResponder()
    }
    
    func clear() {
        otp1Txtfeild.text = nil
        otp2Txtfeild.text = nil
        otp3Txtfeild.text = nil
        otp4Txtfeild.text = nil
    }
}

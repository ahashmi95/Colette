//
//  RegiserView.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 30/09/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

class RegisterView: UIView, FPNTextFieldDelegate, UITextFieldDelegate {

    var onRegister:((_ firstname: String?,
                     _ lastname: String?,
                     _ email: String?,
                     _ mobile: String?,
                     _ isVaild: Bool?,
                     _ countryCode: String?,
                     _ dialCode: String?) -> Void)?

    var isVaild: Bool = false
    var countryCode: String = "SA"
    var dialCode: String = "+966"
    var authType: AuthType = .email

    private lazy var registerCaption: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFonts.fontBySize(size: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.textColor = UIColors.Dimmed
        lbl.text = UIMessage.REGISER_CAPTION
        return lbl
    }()

    private lazy var firstnameTxtfeild: AuthTextField = {
        let txt = AuthTextField(frame: .zero, nil)
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = UIMessage.REGISTER_FIRST_NAME
        txt.textAlignment = .right
        txt.textContentType = UITextContentType.name
      //  txt.keyboardType = .alphabet
        txt.tag = 1
        return txt
    }()

    private lazy var lastnameTxtfeild: AuthTextField = {
        let txt = AuthTextField(frame: .zero, nil)
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = UIMessage.REGISTER_LAST_NAME
        txt.textAlignment = .right
        txt.textContentType = UITextContentType.familyName
     //   txt.keyboardType = .alphabet
        txt.tag = 2
        return txt
    }()

    private lazy var emailTxtfeild: AuthTextField = {
        let txt = AuthTextField(frame: .zero, 0xffe950)
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = UIMessage.EMAIL_PLASHOLDER + "\(AppDM.shared.settings.isEmailOptional ? UIMessage.OPTIONAL : "")"
        txt.textContentType = UITextContentType.emailAddress
        txt.keyboardType = .emailAddress
        txt.tag = 3
        return txt
    }()

    lazy var mobileTxtfeild: FPNTextField = {
        let txt = FPNTextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFonts.fontBySize(size: 16)
        txt.hasPhoneNumberExample = true
        txt.setFlag(for: FPNCountryCode(rawValue: "SA")!)
        txt.backgroundColor = UIColors.Background
        txt.textColor = UIColor(hex: 0x000000)
        txt.placeholder = UIMessage.MOBILE_PHONE_PLACHOOLDER
        txt.textContentType = UITextContentType.telephoneNumber
        txt.borderStyle = .none
        txt.layer.cornerRadius = 5
        txt.layer.masksToBounds = true
        return txt
    }()

    private lazy var verfiyButton: AuthButton = {
        let btn = AuthButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(UIMessage.REGISTER_BTN, for: .normal)
        return btn
    }()

    private lazy var txtStacks: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()

    init(frame: CGRect, view authType: AuthType) {
        super.init(frame: frame)
        self.authType = authType

        self.mobileTxtfeild.delegate = self

        addSubview(registerCaption)
        addSubview(txtStacks)
        addSubview(verfiyButton)

        verfiyButton.addTarget(self, action: #selector(handleSubmit), for: .touchDown)

        txtStacks.addArrangedSubview(firstnameTxtfeild)
        txtStacks.addArrangedSubview(lastnameTxtfeild)
        txtStacks.addArrangedSubview(emailTxtfeild)
        txtStacks.addArrangedSubview(mobileTxtfeild)

        NSLayoutConstraint.activate([

            registerCaption.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            registerCaption.heightAnchor.constraint(equalToConstant: 80),
            registerCaption.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerCaption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            registerCaption.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            txtStacks.topAnchor.constraint(equalTo: registerCaption.bottomAnchor, constant: 10),
            txtStacks.centerXAnchor.constraint(equalTo: centerXAnchor),
            txtStacks.heightAnchor.constraint(equalToConstant: 215),
            txtStacks.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            txtStacks.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            verfiyButton.heightAnchor.constraint(equalToConstant: 50),
            verfiyButton.topAnchor.constraint(equalTo: txtStacks.bottomAnchor, constant: 15),
            verfiyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            verfiyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            verfiyButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        switch authType {
            case .email:
                emailTxtfeild.isHidden = true
            case .mobile:
                mobileTxtfeild.isHidden = true
                emailTxtfeild.delegate = self
                emailTxtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        self.dialCode = dialCode
        self.countryCode = code
    }

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.undoManager?.disableUndoRegistration()
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

        //textField.rightView?.backgroundColor = .red
    }

    @objc func textFieldDidChange(textField: UITextField) {

        // MARK: email Tag
        if textField.tag == 3 {
            textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        guard let text = textField.text else {
            return
        }

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        let v = UIImageView()
        v.image = text.isValidEmail() ? #imageLiteral(resourceName: "success") : UIImage(imageLiteralResourceName: "fail")
        v.alpha = text.isValidEmail() ? 1 : 0.5
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

    }

    @objc func handleSubmit() {
        switch authType {
            case .email:
            onRegister?(firstnameTxtfeild.text, lastnameTxtfeild.text, nil, mobileTxtfeild.getRawPhoneNumber(), isVaild, countryCode, dialCode)
            case .mobile:
                onRegister?(firstnameTxtfeild.text, lastnameTxtfeild.text, emailTxtfeild.text, nil, nil, nil, nil)
            }
    }
}

//
//  PickAuthView.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 29/09/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

enum AuthType: String {
    case email
    case mobile
}

enum SocialLoginType: String {
    case google
    case facebook
    case apple
}

class AuthPickView: UIView, FPNTextFieldDelegate, UITextFieldDelegate {

    var onSubmitMobile:((_ isVaild: Bool, _ countryCode: String, _ dialCode: String, _ mobile: String?) -> Void)?
    var onSubmitEmail:((_ email: String?) -> Void)?
    var onSubmitSocial: ((_ type: SocialLoginType) -> Void)?
    var isVaild: Bool = false
    var countryCode: String = "SA"
    var dialCode: String = "+966"
    var authType: AuthType = .email
    
    var isEdit: Bool = false
    
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
        txt.semanticContentAttribute = .forceLeftToRight
        txt.textAlignment = .left
        return txt
    }()

    private lazy var emailTxtfeild: AuthTextField = {
        let txt = AuthTextField(frame: .zero, nil)
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = UIMessage.EMAIL_PLASHOLDER
        txt.textContentType = UITextContentType.emailAddress
        txt.keyboardType = .emailAddress
        return txt
    }()

    private lazy var verfiyButton: AuthButton = {
        let btn = AuthButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(UIMessage.LOGIN_BTN, for: .normal)
        return btn
    }()
    
    private lazy var socialCaption:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.text = "أو الدخول بواسطة"
        lbl.font = UIFonts.fontBySize()
        lbl.textColor = UIColors.Default
        lbl.sizeToFit()
        lbl.isHidden = !AppDM.shared.settings.socialLogin
        return lbl
    }()
    
    private lazy var dividerRight: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = UIColors.DarkBorder
        view.set(.width, of: 50)
        view.set(.height, of: 1)
        view.isHidden = !AppDM.shared.settings.socialLogin
        return view
    }()
    
    private lazy var dividerLeft: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = UIColors.DarkBorder
        view.set(.width, of: 50)
        view.set(.height, of: 1)
        view.isHidden = !AppDM.shared.settings.socialLogin
        return view
    }()
    
    private lazy var socialCaptionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    private lazy var googleBtn: AuthButton = {
        let btn = AuthButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        let icon = UIImage(named: "google-1")?.resizeImage(targetSize: CGSize(width: 22, height: 22))
        btn.setImage(icon, for: .normal)
        btn.layer.cornerRadius = 25
        btn.backgroundColor = UIColor(hexString: "#EA4335")
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(hexString: "#EA4335").cgColor
        btn.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
        btn.isHidden = !AppDM.shared.settings.googleLoginAvailable
        return btn
    }()
    
    private lazy var facebookBtn: AuthButton = {
        let btn = AuthButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        let icon = UIImage(named: "facebook-1")?.resizeImage(targetSize: CGSize(width: 22, height: 22))
        btn.setImage(icon, for: .normal)
        btn.backgroundColor = UIColor(hexString: "#3b5998")
        btn.layer.cornerRadius = 25
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(hexString: "#3b5998").cgColor
        btn.addTarget(self, action: #selector(handleFacebook), for: .touchUpInside)
        btn.isHidden = !AppDM.shared.settings.facebookLoginAvailavle
        return btn
    }()
    
    private lazy var appleBtn: AuthButton = {
        let btn = AuthButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        let icon = UIImage(named: "apple-1")?.resizeImage(targetSize: CGSize(width: 22, height: 22))
        btn.setImage(icon, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 25
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(handleApple), for: .touchUpInside)
        btn.isHidden = !AppDM.shared.settings.appleLoginAvailable
        return btn
    }()
    
    private lazy var socialStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 16
        stack.axis = .horizontal
        return stack
    }()

    init(frame: CGRect, view authType: AuthType) {
        super.init(frame: frame)
        self.authType = authType
        verfiyButton.addTarget(self, action: #selector(handleSubmitButton), for: .touchDown)

        switch authType {
            case .email:
                setupEmail()
            case .mobile:
                setupMobile()
        }
    }

    func editConfig() {
        self.verfiyButton.setTitle(UIMessage.CHECK_BTN, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeView(view type: AuthType) {

        removeAllSubviews()
        self.authType = type
        switch type {
            case .email:
                setupEmail()
            case .mobile:
                setupMobile()
        }
    }
    
    func hideSocialForEdit(){
        self.socialStack.isHidden = true
        self.socialCaptionContainer.isHidden = true
    }
    
    func setupSocialLogin() {
        
        if isEdit { return }
        socialStack.addArrangedSubview(googleBtn)
        socialStack.addArrangedSubview(appleBtn)
        socialStack.addArrangedSubview(facebookBtn)
        addSubview(socialStack)
        
        socialStack.layoutToSuperview(.bottom, offset: -35, priority: .must)
        socialStack.layoutToSuperview(.centerX)
        socialStack.layout(.top, to: .bottom,of: verfiyButton, relation: .greaterThanOrEqual, offset: 15, priority: .must)
      //  googleBtn.layoutToSuperview(.trailing)
        googleBtn.set(.height,.width, of: 50)
        
       // facebookBtn.layoutToSuperview(.leading)
        facebookBtn.set(.height,.width, of: 50)
        
        appleBtn.set(.height,.width, of: 50)

        addSubview(socialCaptionContainer)
        socialCaptionContainer.set(.height, of: 40)
        socialCaptionContainer.layout(.top, to: .bottom, of: verfiyButton, relation: .greaterThanOrEqual, ratio: 1.0, offset: -15, priority: .must)
        socialCaptionContainer.layout(.bottom, to: .top, of: socialStack, relation: .equal, offset: -15, priority: .must)
        socialCaptionContainer.layoutToSuperview(.leading,.trailing)
        
        socialCaptionContainer.addSubview(socialCaption)
        socialCaptionContainer.addSubview(dividerRight)
        socialCaptionContainer.addSubview(dividerLeft)
        
        socialCaption.layoutToSuperview(.centerX,.centerY)
        dividerLeft.layout(.leading, to: .trailing, of: socialCaption, offset: 15)
        dividerRight.layout(.trailing, to: .leading, of: socialCaption, offset: -15)
        dividerLeft.layout(.centerY, to: .centerY, of: socialCaption)
        dividerRight.layout(.centerY, to: .centerY, of: socialCaption)
    }

    func setupEmail() {
        
        emailTxtfeild.applyMaxWidth()
        verfiyButton.applyMaxWidth()

        addSubview(emailTxtfeild)
        addSubview(verfiyButton)

        emailTxtfeild.delegate = self
        emailTxtfeild.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        emailTxtfeild.set(.height, of: 50)
        emailTxtfeild.layoutToSuperview(.top, relation: .equal, ratio: 1.0, offset: 15, priority: .must)
        emailTxtfeild.layoutToSuperview(.leading, relation:.equal, ratio: 1.0, offset: 20, priority: .must)
        emailTxtfeild.layoutToSuperview(.trailing, relation:.equal, ratio: 1.0, offset: -20, priority: .must)
        
        verfiyButton.set(.height, of: 50)
        verfiyButton.layout(.top, to: .bottom, of: emailTxtfeild, relation: .equal, ratio: 1.0, offset: 15, priority: .must)
        verfiyButton.layoutToSuperview(.leading, relation:.equal, ratio: 1.0, offset: 20, priority: .must)
        verfiyButton.layoutToSuperview(.trailing, relation:.equal, ratio: 1.0, offset: -20, priority: .must)
        
        setupSocialLogin()

    }

    func setupMobile() {

        mobileTxtfeild.applyMaxWidth()
        verfiyButton.applyMaxWidth()
        
        addSubview(mobileTxtfeild)
        addSubview(verfiyButton)

        mobileTxtfeild.delegate = self
        
        mobileTxtfeild.set(.height, of: 50)
        mobileTxtfeild.layoutToSuperview(.top, relation: .equal, ratio: 1.0, offset: 15, priority: .must)
        mobileTxtfeild.layoutToSuperview(.leading, relation:.equal, ratio: 1.0, offset: 20, priority: .must)
        mobileTxtfeild.layoutToSuperview(.trailing, relation:.equal, ratio: 1.0, offset: -20, priority: .must)
        
        verfiyButton.set(.height, of: 50)
        verfiyButton.layout(.top, to: .bottom, of: mobileTxtfeild, relation: .equal, ratio: 1.0, offset: 15, priority: .must)
        verfiyButton.layoutToSuperview(.leading, relation:.equal, ratio: 1.0, offset: 20, priority: .must)
        verfiyButton.layoutToSuperview(.trailing, relation:.equal, ratio: 1.0, offset: -20, priority: .must)
        
//        socialStack.addArrangedSubview(facebookBtn)
//        socialStack.addArrangedSubview(googleBtn)
//        addSubview(socialStack)
//
//        socialStack.layout(.top, to: .bottom, of: verfiyButton, relation: .equal, ratio: 1.0, offset: 15, priority: .must)
//        socialStack.layoutToSuperview(.leading, offset: 20)
//        socialStack.layoutToSuperview(.trailing, offset: -20)
//
//        googleBtn.layoutToSuperview(.trailing)
//        googleBtn.set(.height, of: 50)
//
//        facebookBtn.layoutToSuperview(.leading)
//        facebookBtn.set(.height, of: 50)
        
        setupSocialLogin()
        
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

        //textField.rightView?.backgroundColor = .red
    }

    @objc func textFieldDidChange(textField: UITextField) {

        guard let text = textField.text else {return}

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

    @objc func handleSubmitButton() {
        switch authType {
            case .email:
                self.onSubmitEmail?(emailTxtfeild.text)
            case .mobile:
                self.onSubmitMobile?(isVaild, countryCode, dialCode, mobileTxtfeild.getRawPhoneNumber())
        }
    }
    
    @objc func handleGoogle() {
        self.onSubmitSocial?(.google)
    }
    
    @objc func handleFacebook() {
        self.onSubmitSocial?(.facebook)
    }
    
    @objc func handleApple() {
        self.onSubmitSocial?(.apple)
    }

    func dissableEntry() {
        alpha = 0.8
        self.verfiyButton.layer.borderColor = UIColor.gray.cgColor
        self.verfiyButton.setTitleColor(.white, for: .disabled)
        self.verfiyButton.backgroundColor = .gray
        self.verfiyButton.isEnabled = false
        switch authType {
            case .email:
                self.emailTxtfeild.isEnabled = false
                self.emailTxtfeild.textColor = .gray
            case .mobile:
                self.mobileTxtfeild.isEnabled = false
                self.mobileTxtfeild.textColor = .gray
        }
    }
}

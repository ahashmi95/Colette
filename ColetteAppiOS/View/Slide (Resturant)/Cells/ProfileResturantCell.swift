//
//  ResturantProfileCell.swift
//  SallaCustomerAppIOS
//
//  Created by PogMac on 07/09/2020.
//  Copyright © 2020 Muhammad Fatani. All rights reserved.
//

import UIKit

class ProfileResturantCell: BaseCell {
    
    var onLoginClick: (() -> Void)?
    
    var onExitClick: (() -> Void)?
    
    var onProfileClick: (() -> Void)?
    
    var onLogoutClick: (() -> Void)?
    
    var onShowProfile: (() -> Void)?

    var userProfile: UserProfileVM? {
        didSet {
            guard let theUserProfile = userProfile else { return }
//            lblUsername.text = theUserProfile.userNameText
            ivProfileImage.sd_setImage(with: theUserProfile.avatarUrl)
//            btnLoginProfile.setTitle(theUserProfile.btnTitle, for: .normal)
//            btnLoginProfile.setTitleColor(theUserProfile.btnColor, for: .normal)
//            btnLoginProfile.layer.borderColor = theUserProfile.btnColor?.cgColor
        }
    }
    
    var isLogin: Bool?
    
    private lazy var exitBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = AppDM.shared.mainColor!.cgColor
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "sallaicons", size: 16)
        btn.setTitle(0xea47.iconCode(), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onExit), for: .touchDown)
        return btn
    }()
    
    private lazy var continer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let ivProfileImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = UI.RADIOS
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 0.7
        iv.layer.borderColor = UIColors.LightBorder.cgColor
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "profile_placholder")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.set([.width,.height], to: 75.0)
        return iv
    }()
    
    private let lblUsername: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFonts.fontBySize(type: .bold, size: 16)
//        lbl.text = UIMessage.CAPTION_NAME
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = UIColors.Default
        return lbl
    }()
    
    private lazy var btnLoginProfile: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.backgroundColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFonts.fontBySize(size: 14)
        btn.setTitleColor(AppDM.shared.mainColor, for: .normal)
//        btn.setTitle(UIMessage.LOGIN, for: .normal)
        btn.layer.borderColor = AppDM.shared.mainColor?.cgColor
        btn.addTarget(self, action: #selector(onClick), for: .touchDown)
        btn.accessibilityIdentifier = "profileButton"
        btn.set(.width, of: 120)
        btn.set(.height, of: 32)
        return btn
    }()
    
    private lazy var btnProfile: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onShowProfileHandler), for: .touchDown)
        btn.accessibilityIdentifier = "profileButton"
        btn.set([.width,.height], to: 75.0)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        self.accessibilityIdentifier = "profileCell"
        
        let safeAreaView = UIView()
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.backgroundColor = .white
        safeAreaView.set(.height, of: 60)
        
        contentView.addSubview(safeAreaView)
        safeAreaView.layoutToSuperview(.top, relation: .equal, ratio: 1.0, offset: -50, priority: .must)
        safeAreaView.layoutToSuperview(.leading,.trailing)
        
        contentView.addSubview(continer)
        continer.layoutToSuperview(.top, relation: .equal, ratio: 1.0, offset: 0, priority: .must)
        continer.layoutToSuperview(.leading,.trailing)
        continer.layoutToSuperview(.bottom, relation: .equal, ratio: 1.0, offset: 0, priority: .must)
        
        addSubview(ivProfileImage)
        addSubview(btnProfile)
        ivProfileImage.layout(.centerX, to: .centerX, of: continer, relation: .equal, ratio: 1.0, offset: 12, priority: .must)
        ivProfileImage.layoutToSuperview(.top, relation: .equal, ratio: 1.0, offset: 20, priority: .must)
        btnProfile.layout(.centerX, to: .centerX, of: ivProfileImage, relation: .equal, ratio: 1.0, offset: 12, priority: .must)

        addSubview(lblUsername)
        
        lblUsername.layoutToSuperview(.leading,.trailing)
        lblUsername.layout(.top, to: .bottom, of: ivProfileImage, relation: .equal, ratio: 1.0, offset: 12, priority: .must)
        //        lblUsername.layoutToSuperview(.bottom, relation: .lessThanOrEqual, ratio: 1.0, offset: -10, priority: .must)
        //
        addSubview(btnLoginProfile)
        btnLoginProfile.layout(.centerX, to: .centerX, of: continer, relation: .equal, ratio: 1.0, offset: 12, priority: .must)
        btnLoginProfile.layout(.top, to: .bottom, of: lblUsername, relation: .equal, ratio: 1.0, offset: 12, priority: .must)
    }
    
    func deleteImage () {
        self.ivProfileImage.image = UIImage(named: "profile_placholder")
        self.ivProfileImage.reloadInputViews()
    }
    
    @objc private func onClick() {
        if !isLogin! {
            onLoginClick!()
        } else {
            onLogoutClick!()
        }
    }
    
    @objc private func onShowProfileHandler() {
        if isLogin! {
            onShowProfile?()
        }
    }
    
    @objc private func onExit() {
        onExitClick!()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

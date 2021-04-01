//
//  SliderHomeCell.swift
//  SallaCustomerAppIOS
//
//  Created by PogMac on 06/09/2020.
//  Copyright © 2020 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

class HomeSliderCellView: UIView {

    var item: ResturantSlideViewModel? {
        didSet {
            guard let item = item else { return }
            name.text = item.customName
            icon.text = String(format: "%C", item.customIcon)
        }
    }

    let icon: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "sallaicons", size: 20)
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let name: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFonts.fontBySize(size: 16)
        lbl.textColor = UIColor(hex: 0xff636362)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let arrowIcon: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "sallaicons", size: 14)
        lbl.text = String(format: "%C", 0xea65)
        lbl.textColor = UIColor.lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.isHidden = true
        return lbl
    }()

    func blackmode(on: Bool) {
        if on {
            name.textColor = UIColors.Default
            icon.textColor = UIColors.Dimmed
        } else {
            name.textColor = UIColor(hex: 0xff636362)
            icon.textColor = .gray
        }
    }
    
    func setSelected(result: Bool){
        if result == true {
            icon.textColor = AppDM.shared.authTextColor
            backgroundColor = AppDM.shared.mainColor
            name.textColor = AppDM.shared.authTextColor
            arrowIcon.textColor = AppDM.shared.authTextColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(icon)
        addSubview(name)
        addSubview(arrowIcon)

        backgroundColor = .white

        NSLayoutConstraint.activate([

            icon.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            name.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -15),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            name.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

            arrowIcon.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            arrowIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            arrowIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)

        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeSlideCell: BaseCell {
    
    var onClick:(()->())?

    private lazy var clickButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(handleClick), for: .touchDown)
        return btn
    }()
    
    let paddingView: UIView = {
        let padView = UIView()
        padView.backgroundColor = UIColors.Background
        padView.translatesAutoresizingMaskIntoConstraints = false
        return padView
    }()

    let speratorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColors.Background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    let homeItem: HomeSliderCellView = {
        let loginItem = HomeSliderCellView()
        loginItem.translatesAutoresizingMaskIntoConstraints = false
        return loginItem
    }()
    
    
    var item: ResturantSlideViewModel? {
        didSet {
            guard let item = item else {
                return
            }
            homeItem.item = item
        }
    }
    
    var isfromListWithHeader: Bool? {
        didSet {
            homeItem.blackmode(on: isfromListWithHeader!)
        }
    }

    var paddingHeightConstraint: NSLayoutConstraint?
    
    func setSelected(selected: Bool){
        self.homeItem.setSelected(result: selected)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.accessibilityIdentifier = "loginItems"

        contentView.addSubview(paddingView)
        contentView.addSubview(speratorLine)
        contentView.addSubview(homeItem)
        
        addSubview(clickButton)
        clickButton.fillSuperview()

        paddingHeightConstraint = paddingView.heightAnchor.constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            paddingView.topAnchor.constraint(equalTo: topAnchor),
            paddingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            paddingHeightConstraint!,

            homeItem.topAnchor.constraint(equalTo: paddingView.bottomAnchor),
            homeItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            homeItem.heightAnchor.constraint(equalToConstant: 50),

            speratorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            speratorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            speratorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            speratorLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.speratorLine.isHidden = true
    }
    
    @objc func handleClick() {
        self.onClick?()
    }

}

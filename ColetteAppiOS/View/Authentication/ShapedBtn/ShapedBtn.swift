//
//  ShapedBtn.swift
//  SallaCustomerAppIOS
//
//  Created by Muhammad Fatani on 16/04/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import UIKit

class ShapedBtn: UIView {

    var onClick:(() -> Void)?

    let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        return container
    }()

    let icon: UILabel =  {
        let icon = UILabel()
        icon.font = UIFont(name: "sallaicons", size: 18)
        icon.textColor = UIColor.lightGray
        //icon.adjustsFontSizeToFitWidth = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    let lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFonts.fontBySize(size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    let btn: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        return btn
    }()

    var themeColor: UIColor?

    var isFillBG: Bool?

    var isActive: Bool = false {
        didSet {

            if isFillBG! {
                container.backgroundColor = themeColor!
                lbl.textColor = .white
                icon.textColor = .white
            } else {
                if isActive {
                    container.layer.borderColor =  themeColor!.cgColor
                    container.layer.borderWidth = 1.0
                    lbl.textColor = themeColor
                    icon.textColor = themeColor
                    container.backgroundColor = .clear
                    btn.isUserInteractionEnabled = true
                } else {
                    container.backgroundColor = .clear
                    lbl.textColor = themeColor
                    icon.textColor = UIColors.LighterBorder
                    container.layer.borderColor = UIColors.LighterBorder.cgColor
                    container.layer.borderWidth = 1.0
                    btn.isUserInteractionEnabled = false
                }
            }
        }
    }

    func addTarget(target: Any?, action: Selector?) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }

    init(frame: CGRect, iconCode: Int, text: String, isFillBG: Bool) {
        super.init(frame: frame)

        addSubview(container)
        addSubview(btn)

        let color = AppDM.shared.mainColor ?? .gray

        self.themeColor = color
        self.isFillBG = isFillBG
        icon.text = String(format: "%C", iconCode)
        lbl.text = text

        let stackView = UIStackView(arrangedSubviews: [lbl, icon])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = UIStackView.Alignment.center
        stackView.distribution = UIStackView.Distribution.fillProportionally
        //stackView.spacing = 5.0

        container.addSubview(stackView)
        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),

            btn.topAnchor.constraint(equalTo: topAnchor),
            btn.bottomAnchor.constraint(equalTo: bottomAnchor),
            btn.trailingAnchor.constraint(equalTo: trailingAnchor),
            btn.leadingAnchor.constraint(equalTo: leadingAnchor),

            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5)
        ])

        btn.addTarget(self, action: #selector(handleOnClick), for: .touchDown)

    }

    @objc func handleOnClick() {
        self.onClick?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

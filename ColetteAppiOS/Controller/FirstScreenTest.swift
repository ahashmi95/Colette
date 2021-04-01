//
//  FirstScreenTest.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 25/03/2021.
//
//  CloudSelectorVC.swift
//  SallaCustomerAppIOS
//
//  Created by Abdulrahman A. Hashmi on 26/01/2021.
//  Copyright © 2021 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit
import QuickLayout

class CloudSelectorVC: UIViewController, UITextFieldDelegate {

    private lazy var btnSubmitOrder: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("اختيار الرابط", for: .normal)
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleSubmit), for: .touchDown)
        btn.sizeToFit()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(btnSubmitOrder)
        
        btnSubmitOrder.set([.height, .width], to: 200)
        btnSubmitOrder.layoutToSuperview(.centerX,.centerY)

    }

    @objc func handleSubmit() {
        print("LOL")
    }
}

//
//  ProgressIndicator.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 21/07/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ProgressIndicator: UIView {

    let indicatorView: NVActivityIndicatorView = {
        let view =  NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: AppDM.shared.mainColor)
        view.color = AppDM.shared.mainColor ?? .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set([.width,.height], to: 40)
        return view
    }()

    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0.9
        view.layer.cornerRadius = 8
        view.layer.applySketchShadow(color: .black, alpha: 0.10, x: 0, y: 1, blur: 2, spread: 0)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(container)
        container.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 80),
            container.heightAnchor.constraint(equalToConstant: 80),

            indicatorView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        
    }
    
    func setAnimation(value:Bool) {
        value ? indicatorView.startAnimating() : indicatorView.stopAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  NabBarButtons.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

class BarSaveBTN: UIButton {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        let icon = Tools.getImageByIcon(icon: 0xEA9D, size: 25, color: UIColor(hex: AppDM.shared.iconColor ?? 0xFFFFFF))
        setImage(icon, for: .normal)
        contentMode = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class BarCloseBTN: UIButton {
    
    init() {
        super.init(frame: .zero)
       let icon = Tools.getImageByIcon(icon: 0xEA47, size: 16, color: UIColors.Dimmed)
        setImage(icon, for: .normal)
        contentMode = .center
        backgroundColor = UIColors.BackgroundDarker
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BarClosePlaneBTN: UIButton {
    
    init() {
        super.init(frame: .zero)
       let icon = Tools.getImageByIcon(icon: 0xEA47, size: 26, color: UIColor(hex: AppDM.shared.iconColor ?? 0x000000))
        setImage(icon, for: .normal)
        contentMode = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BarSearchBTN: UIButton {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let icon = Tools.getImageByIcon(icon: 0xEF09, size: 22, color: UIColor(hex: AppDM.shared.iconColor ?? 0x000000))
        setImage(icon, for: .normal)
        contentMode = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BarCallBTN: UIButton {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
         translatesAutoresizingMaskIntoConstraints = false
        let icon = Tools.getImageByIcon(icon: 0xEE41, size: 22, color: UIColor(hex: AppDM.shared.iconColor ?? 0))
        setImage(icon, for: .normal)
        contentMode = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BarBackBTN: UIButton {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
         let icon = Tools.getImageByIcon(icon: 0xEA68, size: 22, color: UIColor(hex: AppDM.shared.iconColor ?? 0xFFFFFF))
         setImage(icon, for: .normal)
         if AppDM.shared.mainColor!.isLight {
//            backgroundColor = AppDM.shared.mainColor?.darker(by: 8)?.withAlphaComponent(0.2)
            backgroundColor = UIColors.Dimmed.withAlphaComponent(0.5)
         } else {
//            backgroundColor = AppDM.shared.mainColor?.lighter(by: 8)?.withAlphaComponent(0.2)
//            backgroundColor = UIColors.Dimmed.withAlphaComponent(0.3)
            backgroundColor = UIColor(hex: AppDM.shared.iconColor ?? 0x444444).withAlphaComponent(0.1)
         }
         contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
         contentMode = .center
         layer.cornerRadius = UI.RADIOS
         translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

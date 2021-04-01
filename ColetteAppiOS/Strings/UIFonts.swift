//
//  UIFonts.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

enum FontType {
    case regular
    case bold
}

struct UIFonts {
    
    static func fontIcon(size:CGFloat = 15.0) -> UIFont {
        return UIFont(name: "sallaicons", size: size)!
    }
    
    static func fontBySize(type:FontType = .regular ,size:CGFloat = 15.0) -> UIFont {
        switch type {
        case .regular:
            return UIFont(name: "DINNextLTArabic-Regular", size: size)!
        case .bold:
            return UIFont(name: "DINNextLTW23-Medium", size: size)!
        }
    }
}

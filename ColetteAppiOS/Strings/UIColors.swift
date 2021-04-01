//
//  UIColors.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

struct UIColors {
    static let NAWAF_GRAY = UIColor(hex: 0xf8f8f8)
    static let BLACK_AUTH = UIColor(red: 0, green: 0, blue: 0, alpha: 60)
    static let APP_COLOR = UIColor(hex: 0x000000)
    static let LIST_ICON = UIColor(hex: 0x8a8a8a)
    static let LIST_TEXT = UIColor(hex: 0x333333)
    static let LIGHT_BLACK = UIColor(hex: 0x5A5A5A)
    static let LIGHTER_BLACK = UIColor(hex: 0x5C5C5C)
    //5C5C5C
    static let LIGHT_GRAY = UIColor(hex: 0xECECEC)
    // LOCAL APP COLORS (USE THIS...)
    static let Default = UIColor(hex: 0x444444)
    static let Dimmed = UIColor(hex: 0x999999)
    static let Disabled = UIColor(hex: 0xE4e4e4)
    static let Green = UIColor(hex: 0x5dd5c4)
    static let Red = UIColor(hex: 0xe46464)
    static let DarkBorder = UIColor(hex: 0xe5e5e5)
    static let LightBorder = UIColor(hex: 0xdddddd)
    static let LighterBorder = UIColor(hex: 0xeeeeee)
    static let Background = UIColor(hex: 0xf8f8f8)
    static let BackgroundDarker = UIColor(hex: 0xeeeeee)
    static let DimmedDarker = UIColor(hex: 0x6a6a6a)
    static let RedAlert = UIColor.init(hex: 4293090653)
    static let DarkGreen = UIColor(hex: 0x52ac59)
}

struct UI {
    static let RADIOS:CGFloat = 8
    static let REST_CELL_RADIOS:CGFloat = 12
    static let REST_MAIN_RADIOS:CGFloat = 12
}

enum SelectOrderType: String {
    case branch = "branch"
    case address = "address"
    case none = "none"
}

enum ScrollDirection {
    case up
    case down
    case reachedTop
    case reachedBottom
}





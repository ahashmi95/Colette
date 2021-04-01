//
//  DevPrint.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation

class DevPrint {

    static var index = 0

    static func print(_ any: Any, type: LogType = .dev) {
        switch type {
            case .dev:
                #if DEBUG
                Swift.print("👨🏻‍💻👨🏻‍💻👨🏻‍💻👨🏻‍💻👨🏻‍💻👨🏻‍💻: \(any)")
                #endif
            case .production:
                index += 1
                Swift.print("#\(index) 📱📱📱📱📱📱📱: \(any)")
        }
    }
}

enum LogType: String {
    case dev
    case production
}

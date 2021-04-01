//
//  SepratorLine.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

class SeparateLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        set(.height, of: 1)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColors.NAWAF_GRAY
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VerticalSeparateLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        set(.width, of: 1)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColors.NAWAF_GRAY
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

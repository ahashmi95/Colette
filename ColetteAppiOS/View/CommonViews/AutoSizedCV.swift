//
//  AutoSizedCV.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

class AutoSizedCollectionView: BaseCollection {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIScreen.main.bounds.width, height: contentSize.height)
    }
}

class AutoSizedCollectionView2: BaseCollection {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        return CGSize(width: UIScreen.main.bounds.width, height: contentSize.height)
    }
}

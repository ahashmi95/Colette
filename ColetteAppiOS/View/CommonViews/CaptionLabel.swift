//
//  CaptionLabel.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit
import QuickLayout

class CaptionLabel:UIView {
    
    private lazy var text: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFonts.fontBySize(type: .regular,size: 18)
        lbl.textColor = AppDM.shared.mainColor
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.layer.masksToBounds = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var caption:UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set(.width, of: 3.5)
        view.backgroundColor = AppDM.shared.mainColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(caption)
        caption.layoutToSuperview(.trailing, relation: .equal, ratio: 1.0, offset: 0, priority: .must)
        caption.layoutToSuperview(.top, relation: .equal, ratio: 1.0, offset: 5, priority: .must)
        caption.layoutToSuperview(.bottom, relation: .equal, ratio: 1.0, offset: -5, priority: .must)
        
        addSubview(text)
        text.layoutToSuperview(.leading, relation: .equal, ratio: 1.0, offset: 0, priority: .must)
        text.layoutToSuperview(.top, relation: .equal, ratio: 1.0, offset: 5, priority: .must)
        text.layoutToSuperview(.bottom, relation: .equal, ratio: 1.0, offset: -5, priority: .must)
        text.layout(.trailing, to: .leading, of: caption, relation: .equal, ratio: 1.0, offset: -5, priority: .must)
        
    }
    
    func setup(meesage:String?) {
        self.text.text = meesage
        if meesage == nil || meesage?.isEmpty ?? true {
            self.caption.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

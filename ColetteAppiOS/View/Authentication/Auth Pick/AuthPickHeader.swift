//
//  AuthPickHeader.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 29/09/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit


class AuthPickHeader: UIView {
    
    var onMobile:(() -> Void)?
    var onEmail:(() -> Void)?
    
    private lazy var appLogo:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 32.5
        image.layer.masksToBounds = true
        image.image = UIApplication.shared.icon
        image.set([.width,.height], to: 75.0)
        return image
    }()
    
    private lazy var caption:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.attributedText = genrateAttrText()
        lbl.sizeToFit()
        return lbl
    }()
    
    private lazy var segment: SegmentView = {
        let view = SegmentView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSegment(withTitle: UIMessage.MOBILE_NUMBER, at: 0, animated: false)
        view.insertSegment(withTitle: UIMessage.EMAIL, at: 1, animated: false)
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(onChangeView), for: .valueChanged)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(appLogo)
        appLogo.layoutToSuperview(.centerX,.top)
        
        addSubview(caption)
        caption.layout(.top, to: .bottom, of: appLogo, relation: .equal, ratio: 1.0, offset: 15, priority: .must)
        caption.layoutToSuperview(.leading,.trailing)
        
        addSubview(segment)
        segment.set(.width, of: 245)
        segment.layout(.top, to: .bottom, of: caption, relation: .equal, ratio: 1.0, offset: 15, priority: .must)
        segment.layoutToSuperview(.centerX)
        segment.layoutToSuperview(.bottom, relation: .equal, ratio: 1.0, offset: -15, priority: .must)
        
        if AppDM.shared.settings.isLogInWithMobile {
            segment.isUserInteractionEnabled = true
            segment.selectedSegmentIndex = 0
        } else {
            segment.removeSegment(at: 0, animated: true)
            segment.isUserInteractionEnabled = false
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onChangeView(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            onEmail?()
        } else {
            onMobile?()
        }
    }
    
    private func genrateAttrText() -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points

        let myTitleAttribute1 = [ NSAttributedString.Key.foregroundColor: UIColors.Default,
                                  NSAttributedString.Key.font: UIFonts.fontBySize(size: 18)]
        let myAttrString1 =       NSAttributedString(string: "\(UIMessage.WELCOME)\n",
                                                     attributes: myTitleAttribute1).withLineSpacing(6)
        
        let myTitleAttribute2 = [ NSAttributedString.Key.foregroundColor: UIColors.Dimmed,
                                  NSAttributedString.Key.font: UIFonts.fontBySize(size: 16)]
        let myAttrString2 =       NSAttributedString(string: UIMessage.WELCOME_LOG_IN,
                                                     attributes: myTitleAttribute2)
        
        let combination = NSMutableAttributedString()
        combination.append(myAttrString1)
        combination.append(myAttrString2)
        
        return combination
    }
    
}

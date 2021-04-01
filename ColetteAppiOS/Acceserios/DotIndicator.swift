//
//  DotIndicator.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit
import QuickLayout
import ImageSlideshow

class DotIndicator:UIView {
        
    lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.set(.height, of: 10)
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColors.LighterBorder.cgColor
        set(.height, of: 18.5)
        addSubview(pageControl)
        pageControl.layoutToSuperview(.leading, relation: .equal, ratio: 1.0, offset: 12.5, priority: .must)
        pageControl.layoutToSuperview(.trailing, relation: .equal, ratio: 1.0, offset: -12.5, priority: .must)
        pageControl.layoutToSuperview(.centerY)
    }
    
    func numberOfPages(_ numberOfPages:Int) {
        self.pageControl.numberOfPages = numberOfPages
    }
    
    func setPage(page:Int) {
        self.pageControl.page = page
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

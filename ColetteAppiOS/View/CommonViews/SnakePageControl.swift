//
//  SnakePageControl.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit
import QuickLayout

class SnakePageControl: UIPageControl {
    
    public var activeColor: UIColor = UIColor(red:0.871, green:0.263, blue:0.239, alpha: 1.000)
    
    public var inactiveColor: UIColor = UIColor(red:0.886, green:0.890, blue:0.898, alpha: 1.000)
    
    public var activeSize: CGSize = CGSize(width: 13, height: 5)
    
    public var inactiveSize: CGSize = CGSize(width: 5, height: 5)
    
    public var dotSpacing: CGFloat = 5.0 {
        didSet {
            if #available(iOS 14.0, *) {
                currentPageIndicatorTintColor = activeColor
                pageIndicatorTintColor = inactiveColor
                self.updateDots_iOS14()
            } else {
                updateDots()
            }
        }
    }
    
    override public var currentPage: Int {
        didSet {
            if #available(iOS 14.0, *) {
                currentPageIndicatorTintColor = activeColor
                pageIndicatorTintColor = inactiveColor
                self.updateDots_iOS14()
            } else {
                updateDots()
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 14.0, *) {
            currentPageIndicatorTintColor = activeColor
            pageIndicatorTintColor = inactiveColor
            self.updateDots_iOS14()
        } else {
            updateDots()
        }
    }
    
    private func updateDots_iOS14() {
        var indicators: [UIView] = []
        
        if #available(iOS 14.0, *) {
            indicators = self.subviews.first?.subviews.first?.subviews ?? []
        } else {
            indicators = self.subviews
        }
        
        for (index, indicator) in indicators.enumerated() {
            let image = self.currentPage == index ? UIImage.init(named: "indicitor-on") : UIImage.init(named: "indicitor-off")
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                if let dot = indicator as? UIImageView {
                    dot.image = image
                } else {
                    let imageView = UIImageView.init(image: image)
                    indicator.addSubview(imageView)
                    // here you can add some constraints to fix the imageview to his superview
                    imageView.layoutToSuperview(.centerX,.centerY)
                }
            })
        }
    }
    
    func updateDots() {
        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        let totalW: CGFloat = CGFloat(numberOfPages - 1) * (inactiveSize.width + dotSpacing) + activeSize.width
        var startX: CGFloat = bounds.width > totalW ? (bounds.width - totalW)/2.0 : 0
        for (idx, dot) in subviews.enumerated() {
            let isActive = idx == currentPage
            let color = isActive ? activeColor : inactiveColor
            let size = isActive ? activeSize: inactiveSize
            let imageV = self.imageView(for: dot, current: self.currentPage)
            let centerPoint = CGPoint(x: dot.bounds.midX, y: dot.bounds.midY)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                dot.frame = CGRect(center: CGPoint(x: size.width/2.0 + startX , y: dot.center.y), size: dot.frame.size)
                imageV?.frame = CGRect(center: centerPoint, size: size)
                imageV?.layer.cornerRadius = min(size.width, size.height)/2.0
                imageV?.backgroundColor = color
            })
            startX += (size.width + self.dotSpacing)
        }
    }
    func imageView(for subview: UIView, current page: Int) -> UIImageView?   {
        
        if let imageV = subview as? UIImageView {
            return imageV
        }
        
        if let imageV = subview.subviews.first(where: { $0.isKind(of: UIImageView.self)
        }) as? UIImageView {
            return imageV
        }
        
        let imageV  = UIImageView(frame: subview.bounds)
        subview.addSubview(imageV)
        return imageV
    }

}

// MARK: ---------------- extension ----------------
public extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init()
        origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        self.size = size
    }
}
public extension UIScrollView {
    var pageNumber: Int {
        get { return Int(contentOffset.x / frame.size.width) }
        set { contentOffset.x = frame.size.width * CGFloat(newValue) }
    }
}

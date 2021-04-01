//
//  PaginationAF.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

class AFPaginationLayout: UICollectionViewFlowLayout {
    
    //  Class properties
    
    var insertingTopCells: Bool = false
    var sizeForTopInsertions: CGSize = CGSize.zero
    
    //  Preparing the layout
    
    override public func prepare() {
        
        super.prepare()
        
        let oldSize: CGSize = sizeForTopInsertions
        
        if insertingTopCells {
            
            let newSize: CGSize  = collectionViewContentSize
            let xOffset: CGFloat = collectionView!.contentOffset.x + (newSize.width - oldSize.width)
            let newOffset: CGPoint = CGPoint(x: xOffset, y: collectionView!.contentOffset.y)
            collectionView!.contentOffset = newOffset
        }
        else {
            insertingTopCells = false
        }
        
        sizeForTopInsertions = collectionViewContentSize
    }

    //  configuring the content offsets relative to the scroll velocity
    //  Solution provided by orlandoamorim
    var lastPoint: CGPoint = CGPoint.zero
    
    //  configuring the content offsets relative to the scroll velocity
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let layoutAttributes: Array = layoutAttributesForElements(in: collectionView!.bounds)!
        
        if layoutAttributes.count == 0 {
            return proposedContentOffset
        }
        var targetIndex = layoutAttributes.count / 2
        
        // Skip to the next cell, if there is residual scrolling velocity left.
        // This helps to prevent glitches
        let vX = velocity.x
        
        if vX > 0 {
            targetIndex += 1
        } else if vX < 0.0 {
            targetIndex -= 1
        }else if vX == 0 {
            return lastPoint
        }
        
        if targetIndex >= layoutAttributes.count {
            targetIndex = layoutAttributes.count - 1
        }
        
        if targetIndex < 0 {
            targetIndex = 0
        }
        
        let targetAttribute = layoutAttributes[targetIndex]
        
        lastPoint = CGPoint(x: targetAttribute.center.x - collectionView!.bounds.size.width * 0.5, y: proposedContentOffset.y)
        return lastPoint
    }
    
}


class PagingCollectionViewLayout: UICollectionViewFlowLayout {
    
    var velocityThresholdPerPage: CGFloat = 2
    var numberOfItemsPerPage: CGFloat = 1
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let pageLength: CGFloat
        let approxPage: CGFloat
        let currentPage: CGFloat
        let speed: CGFloat
        
        if scrollDirection == .horizontal {
            pageLength = (self.itemSize.width + self.minimumLineSpacing) * numberOfItemsPerPage
            approxPage = collectionView.contentOffset.x / pageLength
            speed = velocity.x
        } else {
            pageLength = (self.itemSize.height + self.minimumLineSpacing) * numberOfItemsPerPage
            approxPage = collectionView.contentOffset.y / pageLength
            speed = velocity.y
        }
        
        if speed < 0 {
            currentPage = ceil(approxPage)
        } else if speed > 0 {
            currentPage = floor(approxPage)
        } else {
            currentPage = round(approxPage)
        }
        
        guard speed != 0 else {
            if scrollDirection == .horizontal {
                return CGPoint(x: currentPage * pageLength, y: 0)
            } else {
                return CGPoint(x: 0, y: currentPage * pageLength)
            }
        }
        
        var nextPage: CGFloat = currentPage + (speed > 0 ? 1 : -1)
        
        let increment = speed / velocityThresholdPerPage
        nextPage += (speed < 0) ? ceil(increment) : floor(increment)
        
        if scrollDirection == .horizontal {
            return CGPoint(x: nextPage * pageLength, y: 0)
        } else {
            return CGPoint(x: 0, y: nextPage * pageLength)
        }
    }
}

//
//  BaseCollection.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit
import QuickLayout
import CRRefresh

class BaseCollection: UICollectionView {
    
    var onPullRefresh: (() -> Void)?
    var onPaging: (() -> Void)?
    
    private lazy var refreshAnimator : NormalHeaderAnimator = {
        let animator = NormalHeaderAnimator()
//        animator.loadingDescription = UIMessage.LOADING_DESCRIPTION
//        animator.pullToRefreshDescription = UIMessage.LOADING_PULL
//        animator.releaseToRefreshDescription = UIMessage.LOADING_RELEASE
//        animator.view.transform = CGAffineTransform(scaleX:-1,y: 1);
        return animator
    }()
    
    private lazy var refreshFooter: NormalFooterAnimator = {
        let animator = NormalFooterAnimator()
//        animator.loadingDescription = UIMessage.LOADING_DESCRIPTION
//        animator.loadingMoreDescription = nil
//        animator.noMoreDataDescription = UIMessage.LOADING_NO_MORE
//        animator.view.transform = CGAffineTransform(scaleX:-1,y: 1);
        return animator
    }()
    
    func hideDescription(){
        refreshFooter.loadingMoreDescription = nil
        refreshFooter.noMoreDataDescription = nil
    }
    
    func showDescription(){
//        refreshFooter.noMoreDataDescription = UIMessage.LOADING_NO_MORE
    }
    
    func enablePullToRefresh() {
        self.cr.addHeadRefresh(animator: self.refreshAnimator) { [weak self] in
            /// start refresh do anything you want...
            self?.onPullRefresh?()
        }
    }
    
    func enablePaging() {
        self.cr.addFootRefresh(animator: self.refreshFooter) { [weak self] in
            self?.onPaging?()
        }
    }
    
    func flipAnimator() {
        refreshFooter.view.transform = CGAffineTransform(scaleX:-1,y: 1);
        refreshAnimator.view.transform = CGAffineTransform(scaleX:-1,y: 1);
    }
    
    func disablePaging(){
    }
    
    func stopLoading() {
        self.cr.endHeaderRefresh()
        self.cr.endLoadingMore()
    }
    
    func noMoreDate() {
        self.cr.noticeNoMoreData()
    }
    
    func reload() {
        self.reloadData()
    }
    
    func footerInsets(_ insets: UIEdgeInsets) {
        self.refreshFooter.insets = insets
    }
    
}

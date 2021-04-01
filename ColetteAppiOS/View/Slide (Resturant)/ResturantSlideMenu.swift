//
//  ResturantSlideMenu.swift
//  SallaCustomerAppIOS
//
//  Created by PogMac on 06/09/2020.
//  Copyright © 2020 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit
import DiffableDataSources
import QuickLayout

class ResturantSlideMenu: UIView,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate{
    
    var argCurrencySelect:((_ currency: Currency) -> Void)?
    var argSelectItem: ((AboutViewModel) -> Void)?
    
    private final let slideResturantCellId = "slideResturantCellId"
    private final let homeCellId = "homeCellId"
    private final let profileCellId = "profileCellId"
    private final let sepreatorId = "SepraterCellid"
    private final let currencySectionId = "currencySectionId"
    private final let currencyCellId = "currencyCellId"
    
    private lazy var dataSource = createDataSource()
    var snapshot = Snapshot()

    typealias DataSource = CollectionViewDiffableDataSource<SlideSection, ResturantSlideViewModel>
    typealias Snapshot = DiffableDataSourceSnapshot<SlideSection, ResturantSlideViewModel>
    
    var isOpen = false
    
    var userProfile: UserProfileVM? = nil
    var aboutData: [AboutViewModel]?

    var model = ResturantSlideViewModel()
    
    var onItemTap: ((ResturantSlideViewModel) -> Void)?
    
    var onLoginItemTap: ((ResturantSlideViewModel) -> Void)?
    
    var onLoginBtnClick: (() -> Void)?
    
    var onProfileBtnClick: ((_ user: UserProfileVM?) -> Void)?
    
    var onLogoutSelect: (() -> Void)?
    
    var isLogin: Bool = false {
        didSet {
            switch self.isLogin {
            case true:
                self.appendUserSections()
            case false:
                self.removeUserSections()
            }
        }
    }
    
    var onCloseClick: (() -> Void)?
    
    private let mainViewContainer: UIView
    private let darkView: UIView
    private let tap = UITapGestureRecognizer()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = backgroundColor
        cv.semanticContentAttribute = .forceRightToLeft
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SlideResturantCell.self, forCellWithReuseIdentifier: slideResturantCellId)
        cv.register(ProfileResturantCell.self, forCellWithReuseIdentifier: profileCellId)
        cv.register(SepraterResturantCell.self, forCellWithReuseIdentifier: self.sepreatorId)
        cv.register(HomeSlideCell.self, forCellWithReuseIdentifier: self.homeCellId)
        cv.register(CurrencySectionHeader.self, forCellWithReuseIdentifier: self.currencySectionId)
        cv.register(CurrencyCellRes.self, forCellWithReuseIdentifier: currencyCellId)
        cv.delaysContentTouches = true
        cv.isMultipleTouchEnabled = false
        cv.canCancelContentTouches = true
        return cv
    }()
    
    init(frame: CGRect, mainViewContainer: UIView, darkView: UIView) {
        self.mainViewContainer = mainViewContainer
        self.darkView = darkView
        super.init(frame: frame)
        
//        layer.cornerRadius = 40
//        layer.maskedCorners = [.layerMinXMaxYCorner]
//        clipsToBounds = true
        tap.addTarget(self, action: #selector(handleTap(_:)))
        self.darkView.addGestureRecognizer(tap)
        
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addSubview(collectionView)
        collectionView.layoutToSuperview(.top,.bottom,.trailing,.width)
        
        self.appendProfile()
        self.appendHomeAndPages()
    }
    
    
    func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                switch item.cellType {
                case .profile:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.profileCellId, for: indexPath) as!  ProfileResturantCell
                    cell.onLoginClick = self.onLoginBtnClick
                    cell.onShowProfile = {
                        self.onProfileBtnClick?(self.userProfile)
                    }
                    cell.onProfileClick = {
                        self.onProfileBtnClick?(self.userProfile)
                    }
                    cell.onLogoutClick = {
                        self.onLogoutSelect?()
                    }
                    cell.userProfile = self.userProfile
                    cell.isLogin = self.isLogin
                    cell.onExitClick = {[weak self] in
                        guard let self = self else {return}
                        self.toggleView()
                    }
                    if !self.isLogin {
                        cell.deleteImage()
                    }
                    return cell
                case .userItems:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.slideResturantCellId, for: indexPath) as! SlideResturantCell
                    cell.paddingHeightConstraint?.constant = 0
                    cell.onClick = {
                        if item.customId == "profile" {
                            self.onProfileBtnClick?(self.userProfile)
                        }
                        else {
                            self.onLoginItemTap?(item)
                        }
                    }
                    cell.setupCategory(cat: item)
                    return cell
                case .seprator,.items,.subitems,.logout,.none,.subItems3rd:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.sepreatorId, for: indexPath) as!  SepraterResturantCell
                    return cell
                case .home:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.homeCellId, for: indexPath) as! HomeSlideCell
                    cell.paddingHeightConstraint?.constant = 0
                    cell.item = item
                    cell.setSelected(selected: true)
                    cell.onClick = {
                        self.toggleView()
                    }
                    return cell
                case .page:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.slideResturantCellId, for: indexPath) as! SlideResturantCell
                    cell.paddingHeightConstraint?.constant = 0
                    cell.onClick = {
                        if let subitem = self.aboutData?[indexPath.row] {
                            self.argSelectItem?(subitem)
                        }
                    }
                    cell.setupAbout(about: item.about)
                    return cell
                case .currency:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.currencyCellId, for: indexPath) as! CurrencyCellRes
                    cell.setupSelected()
                    cell.onSelectCurrancy = { currency in
                        self.argCurrencySelect?(currency)
                    }
                    return cell
                case .currencyHeader:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.currencySectionId, for: indexPath) as! CurrencySectionHeader
                    cell.label.text = "العملة"
                    return cell
                }
        })
        return dataSource
    }

    func toggleView() {
        self.onSlideMenu()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: resloveSection(section: indexPath.section))
    }
    
    private func resloveSection(section:Int) -> CGFloat {
        
        // TODO: Guard it to prevent crash
        let sectionData = self.dataSource.snapshot().sectionIdentifiers[section]
        
        if sectionData == .profile {
            return 200.0
        } else if sectionData == .seprator {
            return 20.0
        } else if sectionData == .currencyHeader {
            return 32.0
        } else {
            return 52.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func reloadProfileData() {
        guard let sharedProfile = AppDM.shared.user else { return }
        self.userProfile = sharedProfile
        collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        onSlideMenu()
    }
    
    @objc func onSlideMenu() {
        if !isOpen {
            isOpen = true
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseIn,
                animations: { [weak self] in
                    if let this = self {
                        this.darkView.alpha = 0.4
                        this.darkView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * -0.6, y: 0)
                        this.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * 0.2, y: 0)
                    }
            })
        } else {
            isOpen = false
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: { [weak self] in
                    if let this = self {
                        this.darkView.alpha = 0
                        this.darkView.transform = CGAffineTransform(translationX: 0, y: 0)
                        this.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                    }
            })
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        DevPrint.print("start scroll", type: .dev)
        self.collectionView.isUserInteractionEnabled = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DevPrint.print("end scroll", type: .dev)
        self.collectionView.isUserInteractionEnabled = true
    }
    
    
}

extension ResturantSlideMenu {
    
    private func appendProfile() {
        snapshot.appendSections([.profile])
        snapshot.appendItems([.init("profile", UIMessage.PERSONAL_PROFILE, 0xE96A, cellType: .profile)])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func appendAbout(aboutList:[AboutViewModel]){
        aboutData = aboutList
        for subItem in aboutList {
            snapshot.appendItems([ResturantSlideViewModel(about: subItem.about, cell: .page)], toSection: .page)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
        
    
    private func appendHomeAndPages(){
        snapshot.appendSections([.home])
        snapshot.appendSections([.page])
        snapshot.appendSections([.seprator])
        snapshot.appendSections([.currencyHeader])
        snapshot.appendSections([.currency])

        snapshot.appendItems([.homeItem], toSection: .home)
        snapshot.appendItems([.seperator], toSection: .seprator)
        snapshot.appendItems([.currencyHeader], toSection: .currencyHeader)
        snapshot.appendItems([.currency], toSection: .currency)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func appendUserSections() {
        if !snapshot.sectionIdentifiers.contains(obj: model.userSections) {
            dump(snapshot.sectionIdentifiers)
            snapshot.insertSections(model.userSections, afterSection: .home)
            snapshot.appendItems(ResturantSlideViewModel.loginItems, toSection: .orders)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func removeUserSections() {
        snapshot.deleteSections(model.userSections)
        snapshot.deleteSections([.logout])
        self.reloadProfile()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func reloadProfile() {
        self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
    }
    
}


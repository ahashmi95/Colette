//
//  SearchList.swift
//  SearchAutoComplete
//
//  Created by Amin Fadul on 23/04/2019.
//  Copyright © 2019 AF. All rights reserved.
//

import Foundation
import UIKit

class SearchList: UIView,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {

    var historyData = [String]()

    var results = [ProductViewModel]()

    var paginator: Paginator?

    var onSelectItem: ((Int) -> Void)?
    var onSelectHistory: ((String) -> Void)?
    var argShowAll:(() -> Void)?
    
    var isSearchEmpty: Bool = true
    
    var imageSliderHeight: NSLayoutConstraint!

    
    private let cellId = "SearchResultCell"
    private let cellIdHistory = "HistoryCell"
    private let cellSectionHeaderId = "SectionHeaderCell"
    private let cellEmptyId = "EmptyResultsCell"
    private final let commentMoreCellId = "CommentMoreCellId"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        cv.register(UINib(nibName: cellIdHistory, bundle: nil), forCellWithReuseIdentifier: cellIdHistory)
        cv.register(UINib(nibName: cellSectionHeaderId, bundle: nil), forCellWithReuseIdentifier: cellSectionHeaderId)
        cv.register(UINib(nibName: cellEmptyId, bundle: nil), forCellWithReuseIdentifier: cellEmptyId)
        cv.register(SearchResultNewCell.self, forCellWithReuseIdentifier: cellId)
        cv.register(CommentMoreCell.self, forCellWithReuseIdentifier: commentMoreCellId)
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(collectionView)
        collectionView.layoutToSuperview(.width,.height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if results.count == 0 {
                if isSearchEmpty { return 0 }
                return 1
            } else {
                return results.count + 1
            }
        case 1:
            if historyData.count == 0 {
                return 0
            } else {
                return historyData.count + 1
            }
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch indexPath.section {
        case 0:
             return CGSize(width: frame.width, height: 80)
        case 1:
            if indexPath.row == 0 {
                return CGSize(width: frame.width, height: 50)
            }
            return CGSize(width: frame.width, height: 40)
        default:
            return CGSize(width: 0, height: 0)
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if results.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellEmptyId, for: indexPath) as! EmptyResultsCell
                return cell
            } else {
                if indexPath.row == results.count {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentMoreCellId, for: indexPath) as! CommentMoreCell
                    cell.onShowAll = {
                        self.argShowAll?()
                    }
                    cell.searchMode()
                    return cell
                }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultNewCell
                let item = results[indexPath.row]
                cell.setup(product: item)
//                cell.priceLbl.text = item.priceText
//                cell.titleLbl.text = item.name
//                if !item.imageUrl.isEmpty {
//                    cell.url = item.imageUrl
//                } else {
//                    cell.setUnavailbleImage()
//                }
                return cell
            }
        case 1:
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellSectionHeaderId, for: indexPath) as! SectionHeaderCell
                cell.searchLbl.text = UIMessage.SEARCH_HISTORY
                cell.onClick = {
                    self.historyData.removeAll()
                    self.reload()
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: UserDefaultsKey.SEARCH_HISTORY)
                }
                cell.hideSeperator(state: isSearchEmpty)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdHistory, for: indexPath) as! HistoryCell

            cell.searchIcon.text = String(format: "%C", 0xf014)
            cell.searchLbl.text = historyData[indexPath.row - 1]
            return cell
        default:
            return UICollectionViewCell()
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !results.isEmpty {
            if indexPath.section == 0 {
//                guard let id = results[indexPath.row].id else {return}
                onSelectItem?(results[indexPath.row].id)
            }
        }

        if !historyData.isEmpty {
            if indexPath.section == 1 {
                onSelectHistory?(historyData[indexPath.row - 1])
            }
        }

    }

    func reload() {
        collectionView.reloadData()
        if historyData.isEmpty , results.isEmpty , isSearchEmpty {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }
    
    func hideCollection(){
        collectionView.isHidden = true
    }
    
    func setHistory(data: [String]) {
        self.historyData = data
        reload()
    }

    func setItems(data: [ProductViewModel]) {
        isSearchEmpty = false
        self.results = data
        reload()
    }

    func emptyResults() {
        isSearchEmpty = true
        self.results.removeAll()
        reload()
    }

}


extension UIView {

var heightConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .height && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}
}

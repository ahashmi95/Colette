//
//  SearchBar.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 20/10/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit

class SearchBar: UIView, UITextFieldDelegate {

    var onCancle:(() -> Void)?

    var onTextChange:((_ text: String,_ history: Bool) -> Void)?

    var onEditingBegin:(() -> Void)?

    var onRecordHistory:((_ text: String) -> Void)?

    var onShowSku: (() -> Void)?
    
    var isSearchIconHidden: Bool = true

    var text = ""
        
    var onClearResults:(() -> Void)?
    
    private var timer: Timer?

    private let continerView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    private let searchContainer: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    private let cancleBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(UIMessage.CANCLE, for: .normal)
        btn.tintColor = UIColor.red
        btn.addTarget(self, action: #selector(onCancleSearch), for: .touchUpInside)
        btn.setTitleColor(UIColor(hex: AppDM.shared.iconColor ?? 0xffffff), for: .normal)
        btn.titleLabel?.font = UIFonts.fontBySize(size: 16)
        btn.isHidden = true
        return btn
    }()
    
    private let skuBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onShowSkuSearch), for: .touchUpInside)
        let icon = Tools.getImageByIcon(icon: 0xE980, size: 22, color: .black)
        btn.setImage(icon, for: .normal)
        return btn
    }()

    private let searchTextField: SearchTextField = {
       let txt = SearchTextField()
       txt.translatesAutoresizingMaskIntoConstraints = false
       txt.tag = 10
       txt.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
       txt.accessibilityIdentifier = "SearchTextField"
       return txt
    }()

    private let stack: UIStackView = {
       let stack = UIStackView()
       stack.translatesAutoresizingMaskIntoConstraints = false
       stack.axis  = NSLayoutConstraint.Axis.horizontal
       stack.distribution  = .fillProportionally
       stack.alignment = .center
       stack.spacing = 10.0
       return stack
    }()
    
    func getText() -> String? {
        return self.searchTextField.text
    }

    init(frame: CGRect, bg: Int, searchBarHint: String) {
        super.init(frame: frame)

        addSubview(continerView)

        continerView.backgroundColor = .init(hex: AppDM.shared.appBarColor ?? 0xf8f8f8)
        searchTextField.setup(placeholder: searchBarHint, hostBg: bg)
        searchContainer.addSubview(searchTextField)
        searchTextField.fillSuperview()
        searchContainer.addSubview(skuBtn)
        skuBtn.layoutToSuperview(.leading)
        skuBtn.layoutToSuperview(.top,.bottom)
        skuBtn.set(.width, of: 50)
        
        continerView.addSubview(stack)
        if isSearchIconHidden {
            stack.addArrangedSubview(cancleBtn)
            cancleBtn.set(.width, of: 50)
        }
        stack.addArrangedSubview(searchContainer)

        NSLayoutConstraint.activate([
            continerView.topAnchor.constraint(equalTo: topAnchor),
            continerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            continerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            continerView.leadingAnchor.constraint(equalTo: leadingAnchor),

            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

            searchTextField.topAnchor.constraint(equalTo: stack.topAnchor, constant: 10),
            searchTextField.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: -10)
        ])
        
        searchTextField.delegate = self
        self.accessibilityIdentifier = "SearchBar"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toogleCancel(state: Bool) {
        cancleBtn.hideWithAnimation(hidden: state)
        stack.reloadInputViews()
    }

    func beginEditing() {
        self.searchTextField.becomeFirstResponder()
    }
    
    @objc func onShowSkuSearch() {
        onShowSku?()
    }

    @objc func onCancleSearch() {
        self.searchTextField.text = nil
        onCancle?()
    }

    @objc func textFieldEditingDidChange(_ sender: UITextField) {

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doSearch), object: nil)
        if let text = sender.text {
            toogleCancel(state: text.isEmpty)
            if text != self.text {
                self.text = text
                if self.text.count > 2 {
                    self.startSearchLoading()
                    perform(#selector(doSearch), with: nil, afterDelay: 1)
                } else {
                    self.stopSearchLoading()
                    onClearResults?()
                }
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        onEditingBegin?()
    }

    func addText(text: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doSearch), object: nil)
        toogleCancel(state: text.isEmpty)
        self.text = text
        self.startSearchLoading()
        perform(#selector(doSearchHistory), with: nil, afterDelay: 1)
        self.searchTextField.text = text
    }
    
    func startSearchLoading(){
        cancleBtn.setTitle("", for: .normal)
        cancleBtn.showLoading()
    }
    
    func stopSearchLoading() {
        cancleBtn.setTitle(UIMessage.CANCLE, for: .normal)
        cancleBtn.stopLoadingInd()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.text = nil
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }

    private func runTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: (#selector(doSearch)),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func doSearch() {
        self.startSearchLoading()
        if self.text != "" {
            onTextChange!(self.text, false)
        }
    }
    
    @objc private func doSearchHistory() {
        self.startSearchLoading()
        if self.text != "" {
            onTextChange!(self.text, true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if !text.isEmpty {
                onRecordHistory!(text)
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    
    static let loadingViewTag = 1938123987
    static let barColor = UIColor(hex: AppDM.shared.appBarColor ?? 0xffffff)
    
    func showLoading(style: UIActivityIndicatorView.Style = barColor.isLight ? .gray : .white) {
        var loading = viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
        if loading == nil {
            loading = UIActivityIndicatorView(style: style)
        }
        
        loading?.translatesAutoresizingMaskIntoConstraints = false
        loading!.startAnimating()
        loading!.hidesWhenStopped = true
        loading?.tag = UIView.loadingViewTag
        addSubview(loading!)
        loading?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    // code here
    func stopLoadingInd() {
        let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        loading?.stopAnimating()
        loading?.removeFromSuperview()
    }
}

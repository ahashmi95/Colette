//
//  UI-Extensions.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit
import WebKit
import SwiftMessages

extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore {
        return WKWebsiteDataStore.default().httpCookieStore
    }

    func getCookies(for domain: String? = nil, completion: @escaping ([String: Any]) -> Void) {
        var cookieDict = [String: AnyObject]()

        httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}

extension UITextField {
    convenience init(frame: CGRect, placeholder: String, hostBg: Int, delegate: UITextFieldDelegate) {
        self.init(frame: frame)

        backgroundColor = .white
        let attributedPlaceholder =  NSAttributedString(string: placeholder, attributes: [
            NSAttributedString.Key.font: UIFonts.fontBySize()
        ])

        self.attributedPlaceholder = attributedPlaceholder

        self.font = UIFonts.fontBySize()

        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.rightViewMode = .always

        self.delegate = delegate
        self.returnKeyType = .search
        self.textAlignment = .right
        self.layer.cornerRadius = CGFloat(4)
        self.layer.masksToBounds = false
        self.layer.borderColor = hostBg == 0xffffffff ? UIColor.gray.cgColor : UIColor.red.cgColor
        self.layer.borderWidth = hostBg == 0xffffffff ? 1.0 : 0.0

    }

    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
    }
}

extension UITabBarController {
    func increaseBadge(indexOfTab: Int, num: String) {
        let tabItem = tabBar.items![indexOfTab]
        tabItem.badgeValue = num
    }

    func deleteBadge(indexOfTab: Int) {
        let tabItem = tabBar.items![indexOfTab]
        tabItem.badgeValue = nil
    }

    func openNewVC(controller: UIViewController) {
        if let nav = viewControllers![selectedIndex] as? UINavigationController {
            nav.pushViewController(controller, animated: true)
        }
    }
}

extension UIButton {
    func setActiveStatus(isActive: Bool) {
        if isActive {
            self.layer.borderColor = UIColors.APP_COLOR.cgColor
            self.backgroundColor = .white
            self.setTitleColor(UIColors.APP_COLOR, for: .normal)
            self.isUserInteractionEnabled = true
        } else {
            self.layer.borderColor = UIColor.gray.cgColor
            self.backgroundColor = .gray
            self.setTitleColor(.white, for: .normal)
            self.isUserInteractionEnabled = false
        }
    }
    
    func setInsets(
        forContentPadding contentPadding: UIEdgeInsets,
        imageTitlePadding: CGFloat
    ) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
    
}

extension UIViewController {

    //MARK:TODO *Leagacy isError flag drop it*
    
    func showToastWith(message: String,isError:Bool) {
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 3)
        //config.dimMode = .gray(interactive: true)
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        config.ignoreDuplicates = false

        let view = MessageView.viewFromNib(layout: .messageView)
            
        if isError {
            Vibration.error.vibrate()
            view.configureTheme(.error, iconStyle: .default)
        } else {
            Vibration.success.vibrate()
            view.configureTheme(.success, iconStyle: .default)
        }

        view.configureContent(body: message)
        view.configureIcon(withSize: CGSize(width: 20.0, height: 20.0), contentMode: .scaleAspectFit)
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        view.bodyLabel?.textAlignment = .right
        view.bodyLabel?.layoutToSuperview(.leading,.trailing)
        view.bodyLabel?.font = UIFonts.fontBySize()
        view.tapHandler = { _ in
            SwiftMessages.hide()
        }
        SwiftMessages.hide()
        SwiftMessages.show(config: config, view: view)
    }
    
    func displayToast(message: String,
                      type:Theme,
                      style:  SwiftMessages.PresentationStyle = .top,
                      context: SwiftMessages.PresentationContext = .window(windowLevel: .statusBar),
                      view : MessageView.Layout = .messageView) {
        
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 3)
        config.presentationStyle = style
        config.presentationContext = context
        config.ignoreDuplicates = false
        let view = MessageView.viewFromNib(layout: view)
        view.configureTheme(type, iconStyle: .default)
        view.configureContent(body: message)
        view.configureIcon(withSize: CGSize(width: 20.0, height: 20.0), contentMode: .scaleAspectFit)
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        view.bodyLabel?.textAlignment = .right
        view.bodyLabel?.layoutToSuperview(.leading,.trailing)
        view.bodyLabel?.font = UIFonts.fontBySize()
        view.tapHandler = { _ in
            SwiftMessages.hide()
        }
        SwiftMessages.hide()
        SwiftMessages.show(config: config, view: view)
        
        if type == .success {
            Vibration.success.vibrate()
        } else if type == .warning{
            Vibration.warning.vibrate()
        } else {
            Vibration.error.vibrate()
        }
    }
    
    func displayInAppAlert(title:String?,message:String?,completion: @escaping (Bool) -> ()) {
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 6)
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .alert)
        config.preferredStatusBarStyle = .lightContent
        config.dimMode = .gray(interactive: true)
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: title ?? "",
                              body: message ?? "",
                              iconImage: UIApplication.shared.icon ?? UIImage(named: "star-active")!)
        
        view.bodyLabel?.font = UIFonts.fontBySize(type: .regular, size: 14)
        view.titleLabel?.font = UIFonts.fontBySize(type: .bold, size: 16)
        view.titleLabel?.textAlignment = .right
        view.titleLabel?.layoutToSuperview(.leading,.trailing)
        view.bodyLabel?.textAlignment = .right
        view.bodyLabel?.layoutToSuperview(.leading,.trailing)
        view.button?.isHidden = true
        
        if title == nil {
            view.titleLabel?.isHidden = true
            view.configureContent(body: message ?? "")
        }
        if message == nil {
            view.bodyLabel?.isHidden = true
        }
    
        view.configureIcon(withSize: CGSize(width: 40, height: 40) , contentMode: .scaleAspectFit)
        view.configureDropShadow()

        view.tapHandler = { _ in
            SwiftMessages.hide()
            completion(true)
        }
        
        Vibration.light.vibrate()
        SwiftMessages.show(config: config, view: view)
    }

//    func showAuthScreen(onSuccess: (() -> Void)? = nil) {
//        let nxView = AuthPickVC()
//        nxView.onSuccess = onSuccess
//        let navController = UINavigationController(rootViewController: nxView)
//        navController.presentationController?.delegate = nxView
//        present(navController, animated: true)
//    }

    func removeLineShadow() {
        self.navigationController?
            .navigationBar
            .setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setNavigationBarTitle(title: String, color: UIColor) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.subviews.forEach { (view) in view.removeFromSuperview()}

        navigationItem.title = title

        var titleTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFonts.fontBySize(size:18.0)
        ]

        titleTextAttributes[NSAttributedString.Key.foregroundColor] = color

        navigationBar.titleTextAttributes = titleTextAttributes
    }

    func createBadge(value: String) -> UILabel {
        let badgeLabel = UILabel(frame: CGRect(x: 20, y: -3, width: 23, height: 23))
        badgeLabel.layer.borderColor = UIColor.clear.cgColor
        //        badgeLabel.sizeToFit()
        badgeLabel.layer.borderWidth = 2
        badgeLabel.layer.cornerRadius = 11.5
        badgeLabel.textAlignment = .center
        badgeLabel.layer.masksToBounds = true
        badgeLabel.font = UIFont(name: "PT Mono", size: 8)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .red
        //badgeLabel.isHidden = true
        badgeLabel.text = value
        return badgeLabel
    }

    func setNavigationBarLogo(urlLogo: String) -> UIView {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
//        logo.sd_setImage(with: URL(string: urlLogo)!)
        logo.contentMode = .scaleAspectFit

        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)

        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 3),
            logo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        return view
    }
    
}
extension UIColor {
  static func == (l: UIColor, r: UIColor) -> Bool {
    var r1: CGFloat = 0
    var g1: CGFloat = 0
    var b1: CGFloat = 0
    var a1: CGFloat = 0
    l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    var r2: CGFloat = 0
    var g2: CGFloat = 0
    var b2: CGFloat = 0
    var a2: CGFloat = 0
    r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
  }
}
func == (l: UIColor?, r: UIColor?) -> Bool {
  let l = l ?? .clear
  let r = r ?? .clear
  return l == r
}
extension UIColor {

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF)
    }

    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: min(alpha + percentage/100, 1.0))
        } else {
            return nil
        }
    }

    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.9
    }

}

extension UICollectionView {
    var widestCellWidth: CGFloat {
        let insets = contentInset.left + contentInset.right
        return bounds.width - insets
    }
}

extension UICollectionViewCell {
    
    func toggleIsHighlightedAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0.1, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.5 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.99, y: 0.99) :
                CGAffineTransform.identity
        })
    }
}


extension UIView {

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func hideWithAnimation(hidden: Bool) {
        UIView.transition(with: self, duration: 0.25, options: .curveEaseOut, animations: {
            self.isHidden = hidden
        })
    }

    var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func animateGesture() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = 0.5
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97)
        })
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
            
        })
    }
    
    func addTopInnerShadow() {
        let containerForShadow = UIView()
        containerForShadow.translatesAutoresizingMaskIntoConstraints = false
        containerForShadow.backgroundColor = .red
        containerForShadow.layer.shadowColor = UIColors.Default.cgColor
        containerForShadow.layer.shadowRadius = 30
        containerForShadow.layer.shadowOffset.height = 0
        containerForShadow.layer.shadowOffset.width = 0
        containerForShadow.layer.shadowOpacity = 0.2
        
        addSubview(containerForShadow)
        containerForShadow.layout(.bottom, to: .top, of: self)
        containerForShadow.layoutToSuperview(.leading,.trailing)
        containerForShadow.set(.height, of: 50)
        bringSubviewToFront(containerForShadow)
    }
    
//    func addTopGradient() {
//        let containerForShadow = GradientBlackView()
//        containerForShadow.translatesAutoresizingMaskIntoConstraints = false
//        containerForShadow.set(.height, of: 60)
//
//        addSubview(containerForShadow)
////        containerForShadow.layout(.bottom, to: .top, of: self)
//        containerForShadow.layoutToSuperview(.leading,.trailing,.top)
//        bringSubviewToFront(containerForShadow)
//    }
}

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        self.attributedText = attributedString
    }

    func willBeTruncated() -> Bool {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 3
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        if label.frame.height > self.frame.height {
            return true
        }
        return false
    }

    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }

}

extension UILabel {
    // MARK: - Custom Flags
    private struct AssociatedKeys {
        static var isCopyingEnabled: UInt8 = 0
        static var shouldUseLongPressGestureRecognizer: UInt8 = 1
        static var longPressGestureRecognizer: UInt8 = 2
    }

    /// Set this property to `true` in order to enable the copy feature. Defaults to `false`.
    @IBInspectable var isCopyingEnabled: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isCopyingEnabled, newValue, .OBJC_ASSOCIATION_ASSIGN)
            setupGestureRecognizers()
        }
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.isCopyingEnabled)
            return (value as? Bool) ?? false
        }
    }

    /// Used to enable/disable the internal long press gesture recognizer. Defaults to `true`.
    @IBInspectable var shouldUseLongPressGestureRecognizer: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shouldUseLongPressGestureRecognizer, newValue, .OBJC_ASSOCIATION_ASSIGN)
            setupGestureRecognizers()
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.shouldUseLongPressGestureRecognizer) as? Bool) ?? true
        }
    }

    @objc
    var longPressGestureRecognizer: UILongPressGestureRecognizer? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.longPressGestureRecognizer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.longPressGestureRecognizer) as? UILongPressGestureRecognizer
        }
    }

    // MARK: - UIResponder
    @objc
    override open var canBecomeFirstResponder: Bool {
        return isCopyingEnabled
    }

    @objc
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Only return `true` when it's the copy: action AND the `copyingEnabled` property is `true`.
        return (action == #selector(self.copy(_:)) && isCopyingEnabled)
    }

    @objc
    override open func copy(_ sender: Any?) {
        if isCopyingEnabled {
            // Copy the label text
            let pasteboard = UIPasteboard.general
            pasteboard.string = text
        }
    }

    // MARK: - UI Actions
    @objc internal func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer === longPressGestureRecognizer && gestureRecognizer.state == .began {
            becomeFirstResponder()

            let copyMenu = UIMenuController.shared
            copyMenu.arrowDirection = .default
            if #available(iOS 13.0, *) {
                copyMenu.showMenu(from: self, rect: bounds)
            } else {
                // Fallback on earlier versions
                copyMenu.setTargetRect(bounds, in: self)
                copyMenu.setMenuVisible(true, animated: true)
            }
        }
    }

    // MARK: - Private Helpers
    fileprivate func setupGestureRecognizers() {
        // Remove gesture recognizer
        if let longPressGR = longPressGestureRecognizer {
            removeGestureRecognizer(longPressGR)
            longPressGestureRecognizer = nil
        }

        if shouldUseLongPressGestureRecognizer && isCopyingEnabled {
            isUserInteractionEnabled = true
            // Enable gesture recognizer
            let longPressGR = UILongPressGestureRecognizer(target: self,
                                                           action: #selector(longPressGestureRecognized(gestureRecognizer:)))
            longPressGestureRecognizer = longPressGR
            addGestureRecognizer(longPressGR)
        }
    }
}

extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }

        return icon
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var displayName: String? {
           return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
       }
}

extension UIView {
    func applyMaxWidth() {
        self.set(.width, of: 450, relation: .lessThanOrEqual, ratio: 1.0, priority: .must)
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

public extension Collection {

    /// Convert self to JSON String.
    /// - Returns: Returns the JSON as String or empty string if error while parsing.
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

extension NSAttributedString {
    func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {

        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
}

//
//  Tools.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
//
//  Tools.swift
//  SallaCustomerAppIOS
//
//  Created by Amin Fadul on 24/06/2019.
//  Copyright © 2019 Muhammad Fatani. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Tools {

    static func isiPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad ? true : false
    }
    
//    static func price(currancy: String?, price: String?) -> String {
//        return String(format: UIMessage.PRICE_WITH_CURRANCY, currancy ?? "SAR",String(format:"%.02f", Double(price ?? "0.0") ?? 0.0))
//    }

    static func layoutiPadWidth(width: CGFloat) -> CGFloat {
        let MAX_WIDTH: CGFloat = 450.0
        return width > MAX_WIDTH ? MAX_WIDTH : width
    }

    static func isBlankHTML(content: String) -> Bool {
        if content == "<p><br></p>" || content.isEmpty {
            return true
        }
        return false
    }

    static func logEvent(event: String) {
    }
    
   static func stripFileExtension ( _ filename: String ) -> String {
        var components = filename.components(separatedBy: ".")
        guard components.count > 1 else { return filename }
        components.removeLast()
        return components.joined(separator: ".")
    }

    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    static func convertNumberToEnglish(arabicNumber: String) -> Double {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: arabicNumber)
        let doubleNumber = Double(truncating: final!)
        return doubleNumber
    }

    static func openURL(url: String) {
        if let url = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func openExternalURL(url:String) {
        guard let theUrl = URL(string:url) else {return}
            if UIApplication.shared.canOpenURL(theUrl) {
                if ["http", "https"].contains(theUrl.scheme?.lowercased() ?? "") ||
                    url.contains("tell:") ||
                    url.contains("mailto:") ||
                    url.contains("sms:?body") {
                    self.openURL(url: url)
                }
            }
    }

    static func callNumber(_ phoneNumber: String) {
        if let phoneCallURL = NSURL(string: "telprompt://\(phoneNumber.digits)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL as URL) {
                application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
            }
        }
    }

   static func color(_ rgbColor: Int) -> UIColor {
        return UIColor(
            red: CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
            blue: CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    static func saveImage(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            UserDefaults.standard.set(pngRepresentation, forKey: key)
        }
    }

    static func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
            let image = UIImage(data: imageData) {
            return image
        } else {
            return nil
        }
    }

    static func checkIfChangedSplash(url: String) -> Bool {
        // 1: reterive stored url if there is any
        let storedUrl = UserDefaults.standard.string(forKey: UserDefaultsKey.SPLASH_URL)
        // 2: if nil change accured flag = true
        if storedUrl == nil || storedUrl != url {
            return true
        } else {
            return false
        }
    }

   static func saveAppData(appData: JSON) {
        guard let jsonString = appData.rawString() else { return }
        UserDefaults.standard.set(jsonString, forKey: UserDefaultsKey.APP_DATA)
    }

    static func clearAppDataAndHome() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.APP_DATA)
    }
    

    static func saveCurrancy(currancy: JSON) {
        guard let jsonString = currancy.rawString() else { return }
        UserDefaults.standard.set(jsonString, forKey: UserDefaultsKey.CURRANCY)
    }

//    static func reteriveCurrancy() -> Currency? {
//        let jsonString = UserDefaults.standard.string(forKey: UserDefaultsKey.CURRANCY) ?? ""
//        guard let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) else { return nil }
//        do {
//            let json = try JSON(data: jsonData)
//            if let stringJson = json.rawString() {
//                return Currency.init(json: JSON(parseJSON: stringJson))
//            } else {
//                return nil
//            }
//        } catch {
//            return nil
//        }
//    }

    static func calNumberOfStacks(count: Int, by: Double) -> Int {
        return  Int((Double(count) / by).rounded(.up))
    }
    
    static func getImageByIcon(icon:Int,size:CGFloat,color:UIColor) -> UIImage? {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = .center

        let attributedString = NSAttributedString(
            string: String(format: "%C", icon),
            attributes: [
                NSAttributedString.Key.font: UIFonts.fontIcon(size: size),
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.paragraphStyle: paragraph
        ])

        let size = sizeOfAttributeString(str: attributedString, maxWidth: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image {_ in
            attributedString.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        return image
    }
    
    private static func sizeOfAttributeString(str: NSAttributedString, maxWidth: CGFloat) -> CGSize {
        let size = str.boundingRect(with: CGSize(width: maxWidth, height: 1000), options: (NSStringDrawingOptions.usesLineFragmentOrigin), context: nil).size
        return size
    }
    
    // MARK: TODO take the CSS from file
    static func setHTMLContentWithStyle(content: String, font: String) -> String {
        let content =
        """
        <header>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
        </header>
        <style type='text/css'>

        @font-face
        {
            font-family: 'DINNextLTArabic-Regular';
            font-weight: normal;
            src: url(DINNextLTArabic-Regular.ttf);
        }

        @font-face
        {
            font-family: 'Estedad-Medium';
            font-weight: normal;
            src: url(Estedad-Medium.ttf);
        }

        @font-face
        {
            font-family: 'DubaiW23-Regular';
            font-weight: normal;
            src: url(DubaiW23-Regular.ttf);
        }

        @font-face
        {
            font-family: 'Gulf-Medium';
            font-weight: normal;
            src: url(Gulf-Medium.ttf);
        }
        * {
            direction: rtl;
            text-align: right !important;
        }
        img {
            max-width:100%;
            width:100%;
        }
        p {

        }
        .product-desc p.ql-align-right,
        .product-detials__desc p.ql-align-right,
        .product-desc p.ql-align-justify,
        .product-detials__desc p.ql-align-justify,
        .product-desc p.ql-align-left,
        .product-detials__desc p.ql-align-left {
            text-align: right !important;
        }
        .product-desc > ul,
        .product-detials__desc > ul,
        .product-desc ol,
        .product-detials__desc ol {
            display: block;
            width: 100%;
            height: auto;
            list-style: none;
            margin: 0;
            padding: 0;
        }
        .product-desc > ul li,
        .product-detials__desc > ul li,
        .product-desc ol li,
        .product-detials__desc ol li {
            display: block;
            position: relative;
            min-height: 30px;
            padding-right: 18px;
            margin-bottom: 5px;
            line-height: 1.6;
        }
        .product-desc > ul li:before,
        .product-detials__desc > ul li:before,
        .product-desc ol li:before,
        .product-detials__desc ol li:before {
            content: "\\f111";
            font-family: FontAwesome;
            font-size: 5px;
            position: absolute;
            top: 12px;
            right: 0;
        }
        .product-desc > ol,
        .product-detials__desc > ol {
            counter-reset: ol-list-counter;
        }
        .product-desc > ol li,
        .product-detials__desc > ol li {
            counter-increment: ol-list-counter;
        }

        p {
            font-size: 15px !important;
            display: block;
            text-align: right !important;
            margin: 0 0 5px 0;
        }
        body {
            font-family: '\(font)';
            font-weight: normal;
            font-size: 16;
            word-wrap: break-word;
            originWhitelist={['*']};
        }
        </style>
        <div class="product-desc"> \(content) </div>
        """
        return content
    }
    

}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}


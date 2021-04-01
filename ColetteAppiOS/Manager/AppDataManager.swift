//
//  AppDataManager.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit

class AppDM {
    
    static let shared = AppDM()
    
    // - App id
    
    var appVersion = "4.0.0"
    
    // - UI Elments
    
    var iconFont: String?
    var appColor: Int?
    var appBarColor: Int?
    var cartPostion: Int?
    var iconColor: Int?
    var mainColor: UIColor?
    var authTextColor: UIColor?
    var orignalAppColor: UIColor?
    var firstScreenTitle: String?
    var leftbarIcon: Int?
    var baseUrl: String?
    var colorMainDarker:UIColor?
    var colorMainDark:UIColor?
    var colorReverse:UIColor?
        
    // - App Data
    
//    var currinces: [Currency]?
//    var selectedCurrancy: Currency = Currency.defualt()
//    var settings: AppSettings = AppSettings()
    var user:UserProfileVM?
//    var appTheme:AppTheme = .store
//    var categories: [Category]?
    
//    var assistantBar: AssistantBar?

//    var appBar: AppNavigationBar?
}


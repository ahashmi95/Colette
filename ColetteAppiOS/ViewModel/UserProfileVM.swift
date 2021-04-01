//
//  UserProfileVM.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import UIKit


class UserProfileVM {
    
    let profile: UserProfile
    
     var fName: String {
        return profile.fName ?? ""
    }
    
     var lName: String {
        return profile.lName ?? ""
    }
    
    var fullName: String {
        return getFullName()
    }
    
     var avatarUrl: URL? {
        return URL(string: profile.avatar ?? "")
    }
    
     var email: String {
        return profile.email ?? ""
    }
    
    var birthday: String {
        return profile.birthday ?? ""
    }
    
    var gender: String {
        if profile.gender == "male" {
            return "ذكر"
        } else if profile.gender == "female"{
            return "انثى"
        }
        return ""
    }
    
     var phoneText: String {
        return getMobileNumber()
    }
    
    var genders = [Gender(title: "ذكر", value: "male"),Gender(title: "أنثى", value: "female"),Gender(title: "عدم التحديد", value: "")]
    
    var phoneNumber: Int? {
        return profile.phone?.number ?? 0
    }
    
    var phoneCode: String {
        return profile.phone?.code ?? ""
    }
    
    var phoneCountryCode: String {
        return profile.phone?.country ?? ""
    }
    
//    var storeButtonTitle: String {
//        if TokenManger.shared.isLoggedIn() {
//            return UIMessage.PERSONAL_PROFILE
//        } else {
//            return UIMessage.LOGIN
//        }
//    }
    
//    var btnTitle: String {
//        switch AppDM.shared.appTheme {
//        case .menu:
//            if TokenManger.shared.isLoggedIn() {
//                return UIMessage.LOGOUT
//            } else {
//                return UIMessage.LOGIN
//            }
//        case .store:
//            if TokenManger.shared.isLoggedIn() {
//                return UIMessage.PERSONAL_PROFILE
//            } else {
//                return UIMessage.LOGIN
//            }
//        }
//    }
    
//    var btnColor: UIColor? {
//        if !TokenManger.shared.isLoggedIn() {
//            return AppDM.shared.mainColor
//        } else {
//            return UIColors.Red
//        }
//    }
    
//    var userNameText: String {
//        if TokenManger.shared.isLoggedIn() {
//            return getFullName()
//        } else {
//            return UIMessage.CAPTION_NAME
//        }
//    }
    
    init(profile: UserProfile){
        self.profile = profile
    }
    
    internal func getFullName() -> String {
        return "\(profile.fName ?? "") \(profile.lName ?? "")"
    }
    
    internal func getMobileNumber() -> String {
        if profile.phone == nil { return "" }
        return "\(self.profile.phone?.code ?? "")\(self.profile.phone?.number ?? 0)"
     }
    
    internal func getDict() -> [String:String]{
        return [
            "name" : self.getFullName(),
            "email" : self.email,
            "phone": self.getMobileNumber()
        ]
    }
}

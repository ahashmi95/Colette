//
//  UserProfile.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import SwiftyJSON

class UserProfile {
            
   internal var fName: String?
   internal var lName: String?
   internal var avatar: String?
   internal var email: String?
   internal var phone:Phone?
    var birthday: String?
    var gender: String?

    init(json: JSON) {
        self.fName = json["first_name"].string
        self.lName = json["last_name"].string
        self.avatar = json["avatar"].string
        self.email = json["email"].string
        self.birthday = json["birthday"].string
        self.gender = json["gender"].string
        if let _ = json["phone"].dictionary {
            self.phone = Phone(json: json["phone"])
        }
    }
    
    //MARK: Phone Model -
    class Phone {
        
        var code:String?
        var country:String?
        var number:Int?
        
        init(json: JSON) {
            self.number = json["number"].int
            self.country = json["country"].string
            self.code = json["code"].string
        }
    }
}

class Gender {
    
    var title: String = "عدم التحديد"
    var value: String = ""
    
    init(title: String, value: String){
        self.title = title
        self.value = value
    }
}

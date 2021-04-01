//
//  TokenManager.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//


import Foundation
import Alamofire

class TokenManger: NSObject {

    static let shared = TokenManger()

    /// TODO: implement property wrapper from cart manager for (Token, last_token_refresesh...etc)
    let userDefaults = UserDefaults.standard

    fileprivate override init() {
        super.init()
    }

    func isLoggedIn() -> Bool {
        if let _ = userDefaults.string(forKey: UserDefaultsKey.TOKEN) {
            return true
        } else {
            return false
        }
    }

    func refresh() {
        if let theToken = userDefaults.string(forKey: UserDefaultsKey.TOKEN),
            let theLastTime =  userDefaults.object(forKey: UserDefaultsKey.LAST_TOKEN_REFRASH) as? Date {
            let now = Date()
            let diffranceTime = now.interval(ofComponent: .day, fromDate: theLastTime)
            DevPrint.print(" now time ⏩⏩⏩ : \(now) \n lastTime token was genrated ⏹⏹⏹ : \(theLastTime) \n Diffrance time #️⃣#️⃣#️⃣ : \(diffranceTime)", type: .production)
            if diffranceTime >= 6 {
                guard let store = userDefaults.string(forKey: UserDefaultsKey.STORE) else {return}
//                ApiAuthRefreshToken.refreshToken(storeName: store, oldToken: theToken, complition: { tokenResponse in
//                    if tokenResponse.status == .Success {
//                        if let theToken = tokenResponse.token {
//                            self.userDefaults.set(theToken, forKey: UserDefaultsKey.TOKEN)
//                            self.userDefaults.set(now, forKey: UserDefaultsKey.LAST_TOKEN_REFRASH)
//                            CartManger.shared.assign()
//                            print("token was refreshed : ♻️")
//                        }
//                    } else if tokenResponse.status == .NotAuthorized {
//                        self.distroy()
//                        NotificationCenter
//                            .default
//                            .post(name: NSNotification.Name(rawValue: "refresh_token"), object: nil)
//                        NotificationCenter
//                            .default
//                            .post(name: NSNotification.Name(rawValue: "refresh_token_base"), object: nil)
//                        NotificationCenter
//                            .default
//                            .post(name: NSNotification.Name(rawValue: "reinit"), object: nil)
//                        NotificationCenter
//                            .default
//                            .post(name: NSNotification.Name(rawValue: "clean_cookies"), object: nil)
//                    }
//                })
            }
        }
    }

    func store() {
        let now = Date()
        userDefaults.set(now, forKey: UserDefaultsKey.LAST_TOKEN_REFRASH)
        //checkOneSignalId()
    }

    func checkOneSignalId() {
//        let isSent = userDefaults.bool(forKey: UserDefaultsKey.IS_SENT_ONESIGNAL_ID)
//        if !isSent {
//            DevPrint.print("onToken Refreshed Faild to send OneSingal Id Detected", type: .production)
//            guard let store = userDefaults.string(forKey: UserDefaultsKey.STORE),
//                let token = userDefaults.string(forKey: UserDefaultsKey.TOKEN),
//                let oneSignalId = userDefaults.string(forKey: UserDefaultsKey.ONE_SIGNAL_ID) else {
//                DevPrint.print("\(#function) faild Parsing", type: .production)
//                return
//            }
//            sendOneSignalCode(store: store, token: token, oneSignalId: oneSignalId)
//        }
    }

//    func sendOneSignalCode(store: String, token: String, oneSignalId: String) {
//        ApiOneSignal.getOneSignalToken(store: store, token: token, oneSignalToken: oneSignalId) { (response) in
//            if response.status == .Success {
//                self.userDefaults.set(true, forKey: UserDefaultsKey.IS_SENT_ONESIGNAL_ID)
//            }
//            if response.status == .Fail {
//                self.userDefaults.set(false, forKey: UserDefaultsKey.IS_SENT_ONESIGNAL_ID)
//            }
//        }
//    }

    func distroy() {
       // userDefaults.removeObject(forKey: UserDefaultsKey.MENU_ORDER_TYPE)
        userDefaults.removeObject(forKey: UserDefaultsKey.TOKEN)
        userDefaults.removeObject(forKey: UserDefaultsKey.IS_SENT_ONESIGNAL_ID)
        AppDM.shared.user = nil
        print("token was deleted : 🚧")
    }

}

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

//
//  UserDefaultManager.swift
//  Base-IOS
//
//  Created by Đinh Văn Trình on 28/06/2022.
//

import UIKit

extension UserDefaults {
    
    var isUserVip: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.Keys.KEY_USER_VIP)
        }
        set {
            if UserDefaults.standard.isUserVip != newValue {
                UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.KEY_USER_VIP)
                print("--> send didPaymentSuccess")
                InappManager.share.didPaymentSuccess.send(newValue)
               
            }
        }
    }
    var generateQRCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.TEMPLATE_SELECT_COUNT)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.TEMPLATE_SELECT_COUNT)
        }
    }
    
    var templateSelectCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.GENERATE_QR_COUNT)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.GENERATE_QR_COUNT)
        }
    }
    
    var openAppCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.OPEN_APP_COUNT)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.OPEN_APP_COUNT)
        }
    }
    
    var didShowOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.Keys.DID_SHOW_ONBOARDING)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.DID_SHOW_ONBOARDING)
        }
    }
    
    var isFirstLanguage: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.Keys.FIRST_LANGUAGE)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.FIRST_LANGUAGE)
        }
    }
    
    var generatePerDay: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.GENERATE_PER_DAY)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.GENERATE_PER_DAY)
        }
    }
    
    var regeneratePerDay: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.REGENERATE_PER_DAY)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.REGENERATE_PER_DAY)
        }
    }
    
    var lastDayOpenApp: Date? {
        get {
            return UserDefaults.standard.value(forKey: Constants.Keys.KEY_LAST_DAY_OPEN_APP) as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.KEY_LAST_DAY_OPEN_APP)
        }
    }
    
    var tooltipsDone: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.Keys.TOOLTIPS_DONE)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.TOOLTIPS_DONE)
        }
    }
}

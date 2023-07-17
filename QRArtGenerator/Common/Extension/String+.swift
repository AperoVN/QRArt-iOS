//
//  String+.swift
//  QRArtGenerator
//
//  Created by ANH VU on 10/07/2023.
//

import Foundation
import UIKit

extension String {
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isEmptyOrWhitespace() -> Bool {
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidUrl() -> Bool {
        let urlRegex = "((http|https)://)?([(w|W)]{3}+\\.)?+(.)+\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlPred = NSPredicate(format:"SELF MATCHES %@", urlRegex)
        return urlPred.evaluate(with: self)
    }
    
    func replaceString(withRegex regex: String, by strValue: String) -> String {
        let regex = try! NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, self.count)
        if range.location != NSNotFound {
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: strValue)
        } else {
            return self
        }
    }
}

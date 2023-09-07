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
    
    func validateURL() -> (isValid: Bool, urlString: String) {
        var url = self
        
        if !url.lowercased().hasPrefix("http://") && !url.lowercased().hasPrefix("https://") {
            url = "https://" + url.trim
        }
        
        let urlRegEx = "(http|ftp|https):\\/\\/([\\w+?\\.\\w+])?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?+([a-zA-Z0-9\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)_\\-\\=\\+\\\\\\/\\?\\.\\:\\;\\'\\,]*)?"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
  
        let result = urlTest.evaluate(with: url.lowercased().removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        
        if result {
            return (true, url.trim)
        } else {
            return (false, "")
        }
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
    
    func withBoldText(boldPartsOfString: Array<String>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
}

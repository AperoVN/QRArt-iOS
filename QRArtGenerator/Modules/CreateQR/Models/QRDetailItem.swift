//
//  QRDetailItem.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import SwiftUI

struct QRDetailItem: QRItem {
    var id: String = ""
    var name: String = ""
    var createdDate: Date = Date()
    var qrImage: UIImage = UIImage()
    var type: QRType = .website
    var groupType: QRGroupType = .basic
    var templateId: String = ""
    var urlString: String = ""
    
    // Contact
    var contactName: String = ""
    var phoneNumber: String = ""
    
    // Text
    var text: String = ""
    
    // Email
    var emailAddress: String = ""
    var emailSubject: String = ""
    var emailDescription: String = ""
    
    // Wifi
    var wfSsid: String = ""
    var wfPassword: String = ""
    var wfSecurityMode: WifiSecurityMode = .wep
    
    // Paypal
    var paypalAmount: String = ""
    
    // Advanced
    var prompt: String = ""
    var negativePrompt: String = ""
    var guidance: Double = .zero
    var contronetScale: Double = .zero
    var steps: Double = .zero
    
    func convertToDB(isNew: Bool = true) -> QRItemDB {
        let object = QRItemDB()
        if !isNew {
            object.ID = id
        }
        object.name = name
        object.createdDate = createdDate
        object.type = type
        object.groupType = groupType
        object.templateId = templateId
        object.urlString = urlString
        object.contactName = contactName
        object.phoneNumber = phoneNumber
        object.text = text
        object.emailAddress = emailAddress
        object.emailSubject = emailSubject
        object.emailDescription = emailDescription
        object.wfSsid = wfSsid
        object.wfPassword = wfPassword
        object.wfSecurityMode = wfSecurityMode
        object.paypalAmount = paypalAmount
        object.prompt = prompt
        object.negativePrompt = negativePrompt
        object.guidance = Int(guidance)
        object.contronetScale = Int(contronetScale)
        object.steps = Int(steps)
        return object
    }
}

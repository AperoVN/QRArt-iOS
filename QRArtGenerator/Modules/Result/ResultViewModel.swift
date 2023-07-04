//
//  ResultViewModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 04/07/2023.
//

import Foundation
import UIKit
import Combine
import SwiftUI

enum Resolutions {
    case normal
    case high
    
    var size: CGSize {
        switch self {
        case .normal:
            return CGSize(width: 256, height: 256)
        case .high:
            return CGSize(width: 1024, height: 1024)
        }
    }
}

class ResultViewModel: ObservableObject {
    @Published var item: QRDetailItem
    @Published var isShowSuccessView: Bool = false
    @Published var isShowLoadingView: Bool = false
    @Published var image: Image
    @Published var sheet: Bool = false
    @Published var source: ResultViewSource
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init(item: QRDetailItem, image: Image, source: ResultViewSource) {
        self.item = item
        self.image = image
        self.source = source
    }
    
    func save() {
        QRItemService.shared.saveNewQR(item)
        isShowSuccessView = true
    }
    
    func scaleImage(resolutions: Resolutions) -> UIImage? {
        let originalImage = item.qrImage
        UIGraphicsBeginImageContextWithOptions(resolutions.size, false, 0.0)
        originalImage.draw(in: CGRect(x: 0, y: 0, width: resolutions.size.width, height: resolutions.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func download() {
        if let image = scaleImage(resolutions: .normal) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
    }
    
    func download4k() {
        if let image = scaleImage(resolutions: .high) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
    }
    
    func genQRLocal(text: String) -> Data? {
        return QRHelper.genQR(text: text)
    }
    
    func regenerate() {
        guard let data = genQRLocal(text: getQRText()) else { return }
        isShowLoadingView.toggle()
        templateRepository.genQR(data: data,
                                 qrText: getQRText(),
                                 positivePrompt: item.prompt,
                                 negativePrompt: item.negativePrompt,
                                 guidanceScale: Int(item.guidance),
                                 numInferenceSteps: Int(item.steps),
                                 controlnetConditioningScale: Int(item.contronetScale))
        .sink { comple in
            self.isShowLoadingView.toggle()
        } receiveValue: { data in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            self.item.qrImage = uiImage
            self.image = Image(uiImage: uiImage)
        }.store(in: &cancellable)
    }
    
    func share() {
        sheet.toggle()
    }
    
    func getQRText() -> String {
        switch item.type {
        case .website, .instagram, .facebook, .twitter, .spotify, .youtube:
            return item.urlString
        case .contact, .whatsapp:
            return item.phoneNumber
        case .email:
            return "MATMSG:TO:\(item.emailAddress);SUB:\(item.emailSubject);BODY:\(item.emailDescription);;"
        case .text:
            return item.text
        case .wifi:
            return "WIFI:S:\(item.wfSsid);P:\(item.wfPassword);T:\(item.wfSecurityMode.title);;"
        case .paypal:
            return "\(item.urlString)/\(item.paypalAmount)"
        }
    }
}

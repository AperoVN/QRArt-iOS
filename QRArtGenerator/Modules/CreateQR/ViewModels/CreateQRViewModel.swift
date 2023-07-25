//
//  CreateQRViewModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import Foundation
import SwiftUI
import Combine
import MobileAds

class CreateQRViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var countrySelect: Country = Country(code: "US", dialCode: "+1")
    @Published var templates: [Template] = []
    @Published var indexSelectTemplate: Int? {
        didSet {
            if let indexSelectTemplate = indexSelectTemplate, !templates.isEmpty {
                input.prompt = templates[indexSelectTemplate].positivePrompt
                input.negativePrompt = templates[indexSelectTemplate].negativePrompt
            }
        }
    }
    @Published var input: QRDetailItem = QRDetailItem() {
        didSet {
            if input.type != oldValue.type {
                validInput = false
                resetInput()
            }
        }
    }
    @Published var validInput: Bool = false
    @Published var source: CreateQRViewSource = .create
    @Published var showingSelectQRTypeView: Bool = false
    @Published var showingSelectCountryView: Bool = false
    @Published var isShowLoadingView: Bool = false
    @Published var isShowExport: Bool = false
    @Published var imageResult: Image = Image("")
    @Published var showSub: Bool = false
    @Published var showToastError: Bool = false
    @Published var isPush: Bool
    @Published var mode: AdvancedSettingsMode = .collapse
    @Published var idTemplateSelect: String?
    @Published var templateSelect: Template?
    @Published var isLoadAdsSuccess: Bool = true
    @Published var errorInputType: TextFieldType?
    private var needFetchTemplates: Bool = true
    var messageError: String = ""
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.bool(forKey: .inter_generate) && !UserDefaults.standard.isUserVip
    }
    
    var isShowAdsBanner: Bool {
        return RemoteConfigService.shared.bool(forKey: .banner_tab_bar) && !UserDefaults.standard.isUserVip
    }
    
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init(source: CreateQRViewSource, templateSelect: Template?, isPush: Bool = false) {
        self.source = source
        self.isPush = isPush
        self.templateSelect = templateSelect
        self.templates.insert(Template(), at: 0)
    }
    
    deinit {
        cancellable.removeAll()
    }
    
    func fetchCountry() {
        countries = CountriesFetcher().fetch()
    }
    
    func fetchTemplate() {
        if needFetchTemplates {
            templateRepository.fetchTemplates().sink { comple in
                switch comple {
                case .finished:
                    self.indexSelectTemplate = 1
                    self.needFetchTemplates = false
                case .failure:
                    self.indexSelectTemplate = 0
                }
                
            } receiveValue: { [weak self] listTemplates in
                guard let self = self else { return }
                if let listTemplates = listTemplates {
                    self.templates.append(contentsOf: listTemplates.items)
                    if let index = self.templates.firstIndex(where: {$0 == self.templateSelect}) {
                        self.templates.swapAt(1, index)
                    }
                }
            }.store(in: &cancellable)
        }
    }
    
    func generateQR() {
        validInput = true
        errorInputType = getErrorInput()
        if errorInputType == nil {
            genQR()
        }
    }
    
    public func createIdAds() {
        if isShowAdsInter {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_generate)
        }
    }
    
    public func showAdsInter() {
        if isShowAdsInter {
            AdMobManager.shared.showIntertitial(unitId: .inter_generate, blockWillDismiss: { [weak self] in
                guard let self = self else { return }
                self.generateQR()
            })
        } else {
            generateQR()
        }
    }
    
    public func onTapGenerate() {
        validInput = true
        errorInputType = getErrorInput()
        if errorInputType == nil {
            if UserDefaults.standard.isUserVip {
                generateQR()
            } else {
                if UserDefaults.standard.generatePerDay >= RemoteConfigService.shared.number(forKey: .subGenerateQr) {
                    // show sub
                    showSub = true
                } else {
                    // show ads
                    showAdsInter()
                }
            }
        }
    }
    
    func getErrorInput() -> TextFieldType? {
        if input.name.isEmptyOrWhitespace() {
            return .name
        }
        switch input.type {
        case .website, .facebook, .instagram, .spotify, .youtube, .twitter:
            if input.urlString.isEmptyOrWhitespace() {
                return .link
            }
            let valid = input.urlString.validateURL()
            if valid.isValid {
                input.urlString = valid.urlString
            } else {
                return .link
            }
        case .contact:
            if input.phoneNumber.isEmptyOrWhitespace() || !input.phoneNumber.isValidPhone() {
                return .contactPhone
            }
        case .email:
            if input.emailAddress.isEmptyOrWhitespace() || !input.emailAddress.isValidEmail() {
                return .email
            }
            if input.emailSubject.isEmptyOrWhitespace() {
                return .emailSubject
            }
            if input.emailDescription.isEmptyOrWhitespace() {
                return .emailDesc
            }
        case .text:
            if input.text.isEmptyOrWhitespace() {
                return .text
            }
        case .whatsapp:
            if input.phoneNumber.isEmptyOrWhitespace() || !input.phoneNumber.isValidPhone() {
                return .contactPhone
            }
        case .wifi:
            if input.wfSsid.isEmptyOrWhitespace() {
                return .wifiID
            }
            if input.wfPassword.isEmptyOrWhitespace() {
                return .wifiPass
            }
        case .paypal:
            if input.urlString.isEmptyOrWhitespace() {
                return .link
            }
            let valid = input.urlString.validateURL()
            if valid.isValid {
                if !input.paypalAmount.isEmptyOrWhitespace() && Int(input.paypalAmount) != nil {
                    input.urlString = valid.urlString
                } else {
                    return .paypal
                }
            } else {
                return .link
            }
        }
        if input.prompt.isEmpty {
            if mode == .collapse {
                mode = .expand
            }
            return .prompt
        }
        return nil
    }
    
    func genQR() {
        isShowLoadingView.toggle()
        templateRepository.genQR(qrText: getQRText(),
                                 positivePrompt: input.prompt,
                                 negativePrompt: input.negativePrompt,
                                 guidanceScale: Int(input.guidance),
                                 numInferenceSteps: Int(input.steps))
        .sink { [weak self] comple in
            guard let self = self else { return }
            switch comple {
            case .finished:
                self.isShowLoadingView.toggle()
            case .failure(let error):
                self.isShowLoadingView.toggle()
                self.messageError = error.message
                self.showToastError.toggle()
            }
        } receiveValue: { [weak self] data in
            guard let self = self,
                  let data = data,
                  let uiImage = UIImage(data: data) else {
                self?.messageError = Rlocalizable.could_not_load_data()
                self?.showToastError.toggle()
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.input.qrImage = uiImage
                self?.imageResult = Image(uiImage: uiImage)
                UserDefaults.standard.generatePerDay += 1
                self?.isShowExport.toggle()
            }
        }.store(in: &cancellable)
        
    }
    
    func getQRText() -> String {
        switch input.type {
        case .website, .instagram, .facebook, .twitter, .spotify, .youtube:
            return input.urlString
        case .contact, .whatsapp:
            return countrySelect.dialCode + input.phoneNumber
        case .email:
            return "MATMSG:TO:\(input.emailAddress);SUB:\(input.emailSubject);BODY:\(input.emailDescription);;"
        case .text:
            return input.text
        case .wifi:
            let mode = WifiSecurityMode(rawValue: input.indexWfSecurityMode) ?? .wpa2
            input.wfSecurityMode = mode
            return "WIFI:S:\(input.wfSsid);P:\(input.wfPassword);T:\(input.wfSecurityMode.title);;"
        case .paypal:
            return "\(input.urlString)/\(input.paypalAmount)"
        }
    }
    
    func resetInput() {
        input = input.duplicate()
    }
}

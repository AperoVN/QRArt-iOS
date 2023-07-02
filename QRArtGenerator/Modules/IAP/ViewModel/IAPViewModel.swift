//
//  IAPViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 02/07/2023.
//

import Foundation

class IAPViewModel: ObservableObject {
    let featureTitles: [String] = [Rlocalizable.no_advertisements(),
                                   Rlocalizable.unlimited_qr_generation(),
                                   Rlocalizable.download_4k_quality(),
                                   Rlocalizable.unlock_all_premium_styles()]
    @Published var iapIds: [IAPIdType] = []
    @Published var selectedIndex: Int = 0
    @Published var showTerms = false
    @Published var showPolicy = false
    
    func getInfoIAP() {
        iapIds = IAPIdType.getOption()
        if InappManager.share.listProduct.isEmpty {
            InappManager.share.productInfo(id: InappManager.share.productIdentifiers) { [weak self] product in
                self?.iapIds = IAPIdType.getOption()
            }
        } else {
            iapIds = IAPIdType.getOption()
        }
    }
}
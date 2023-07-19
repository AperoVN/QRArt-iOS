//
//  AdmobBannerView.swift
//  QRArtGenerator
//
//  Created by khac tao on 01/07/2023.
//

import Foundation
import SwiftUI
import MobileAds
import SnapKit

struct BannerView: UIViewControllerRepresentable {
    
    private let bannerView = UIView()
    var adUnitID: AdUnitID
    var fail: VoidBlock?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        AdMobManager.shared.removeAd(unitId: adUnitID.rawValue)
        let adViewController = AdViewController()
        adViewController.view.addSubview(bannerView)
        let lineView = UIView()
        lineView.backgroundColor = R.color.color_EAEAEA()
        adViewController.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.leading.trailing.equalToSuperview()
        }
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        AdMobManager.shared.addAdBanner(unitId: adUnitID, rootVC: adViewController, view: bannerView)
        AdMobManager.shared.blockBannerFaild = { id in
            if id == adUnitID.rawValue {
                adViewController.view.isHidden = true
                fail?()
            }
        }
        return adViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
    
    


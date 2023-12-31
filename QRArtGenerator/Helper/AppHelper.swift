//
//  AppHelper.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 29/06/2023.
//

import Foundation
import SwiftUI
import NetworkExtension
import MobileAds

struct AppHelper {
    
    public static func getVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }
    
    static func getRootViewController() -> UIViewController? {
        keyWindow?.rootViewController
    }
    
    static func topViewController(controller: UIViewController? = keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let child = controller?.children.first {
            return topViewController(controller: child)
        }
        return controller
    }
    
    static func findTextField(in view: UIView?) -> UITextField? {
        if let textField = view as? UITextField {
            return textField
        }
        for subview in view?.subviews ?? [] {
            if let textField = findTextField(in: subview) {
                return textField
            }
        }
        return nil
    }
    
    static var templates: [Template] = []
    
}

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}


struct ActivityView: UIViewControllerRepresentable {
    var url: String
    @Binding var showing: Bool
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        var activityItems: [Any] = []
        if let url = URL(string: url) {
            activityItems = [url]
        } else {
            activityItems = [url]
        }
        let vc = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.showing = false
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

extension AdUnitID {
    static let inter_change_screen = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/3730109139")
    static let inter_inspire = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/4061281622")
    static let native_result = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-6530974883137971/6291805244")
    static let app_open_high_floor = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-6530974883137971/6973421391")
    static let app_open_all_price = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-6530974883137971/1721094710")
    static let banner_tab_bar = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatBanner : "ca-app-pub-6530974883137971/7922189910")
    
    static let open_splash = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-4584260126367940/6440542072")
    
    static let native_home = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-4584260126367940/8766202955")
    static let inter_template = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-4584260126367940/5573063405")
    static let banner_result = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatBanner : "ca-app-pub-4584260126367940/1302645902")
    static let native_resultback = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-4584260126367940/7849788671")
    static let reward_regen = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatRewarded : "ca-app-pub-6530974883137971/7922189910")
    static let inter_createmore = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-4584260126367940/2465600057")
    static let inter_scanopenlink = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/7922189910")
    static let inter_openmail = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/7922189910")
    static let banner_scan = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatBanner : "ca-app-pub-4584260126367940/4265766883")
    static let reward_generator = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatRewarded : "ca-app-pub-4584260126367940/2309725374")
    static let inter_home = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/2175072003")
    static let inter_regen = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-4584260126367940/3056626992")
    static let banner_collabsible1 = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatCollapsibleBanner : "ca-app-pub-4584260126367940/2789033686")
}

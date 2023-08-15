//
//  HomeView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import SwiftUI
import MobileAds

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    let cellWidth = (WIDTH_SCREEN-55)/2.0
    var generateQRBlock: ((Template) -> Void)?
    var showIAP: VoidBlock?
    
    var body: some View {
        let spacing: CGFloat = 15
        RefreshableScrollView {
            let count = Float(viewModel.templates.count)/2.0
            HStack(alignment: .top, spacing: spacing) {
                VStack {
                    ForEach(0..<Int(count.rounded(.up)), id: \.self) { i in
                        itemView(viewModel.templates[i*2])
                        if viewModel.isLoadAd, (i+1)%3 == 0 {
                            let index = ((i+1)/3)*2
                            if index < viewModel.nativeViews.count {
                                AdNativeViewMultiple(nativeView: viewModel.nativeViews[index]) .frame(width: cellWidth, height: cellWidth*4/3).clipped().background(Color.white).cornerRadius(28)
                            }
                        }
                    }
                }.frame(maxWidth: .infinity)
                
                VStack {
                    Spacer().frame(height: 40)
                    ForEach(0..<Int(count.rounded(.down)), id: \.self) { i in
                        itemView(viewModel.templates[i*2+1])
                        if viewModel.isLoadAd, i%3 == 0 {
                            let index = (i/3)*2+1
                            if index < viewModel.nativeViews.count {
                                AdNativeViewMultiple(nativeView: viewModel.nativeViews[index]) .frame(width: cellWidth, height: cellWidth*4/3).clipped().background(Color.white).cornerRadius(28)
                            }
                           
                        }
                    }
                }.frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            Spacer().frame(height: 120)
        }
        .onAppear {
            FirebaseAnalytics.logEvent(type: .home_view)
        }
        .toast(message: viewModel.msgError, isShowing: $viewModel.isShowToast, duration: 3)
        .refreshable {
            viewModel.fetchTemplate()
        }
    }
    
    private func itemView(_ template: Template) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(
                        AsyncImage(url: URL(string: template.key)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .empty:
                                EmptyView()
                                    .skeleton(with: true, size: CGSize(width: cellWidth, height: cellWidth))
                                    .shape(type: .rounded(.radius(8)))
                            default:
                                R.image.img_error.image
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(height: 150)
                            }
                        }
                    )
                    .cornerRadius(25, corners: [.topLeft, .topRight])
                    .padding([.top, .leading, .trailing], 5)
                    .padding(.bottom, 16)
                Spacer()
                Text(template.name)
                    .font(R.font.beVietnamProMedium.font(size: 14))
                    .foregroundColor(R.color.color_1B232E.color)
                    .padding(.bottom)
                Spacer()
            }
            if template.packageType != "basic" && !UserDefaults.standard.isUserVip {
                Image(R.image.ic_style_sub.name)
                    .padding(.top, 13)
                    .padding(.trailing, 11)
            }
        }
        .frame(width: cellWidth, height: cellWidth*4/3)
        .background(Color.white.opacity(0.55))
        .cornerRadius(30)
        .onTapGesture {
            if template.packageType != "basic" && !UserDefaults.standard.isUserVip {
                showIAP?()
                return
            }
            UserDefaults.standard.templateSelectCount += 1
            if viewModel.isShowSelectInter() {
                AdMobManager.shared.showIntertitial(unitId: .inter_template, blockDidDismiss: {
                    generateQRBlock?(template)
                })
            } else {
                generateQRBlock?(template)
            }
       
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

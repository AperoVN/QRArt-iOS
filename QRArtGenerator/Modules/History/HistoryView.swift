//
//  HistoryView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: - Variables
    @StateObject var viewModel = HistoryViewModel()
    var createQRBlock: VoidBlock?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(Rlocalizable.my_qr()).font(R.font.beVietnamProBold.font(size: 28))

                Spacer()
                if !UserDefaults.standard.isUserVip {
                    LottieView(lottieFile: R.file.crownJson.name)
                        .frame(width: 48, height: 48)
                        .offset(CGSize(width: 8, height: 0))
                        .onTapGesture {
                            viewModel.showIAP.toggle()
                        }
                }
                NavigationLink(destination: SettingsView()) {
                    Image(R.image.setting_ic.name)
                        .colorMultiply(R.color.color_1B232E.color)
                }
            }
            .frame(width: WIDTH_SCREEN - 32, height: 48)
            .background(Color.clear)
            
            if viewModel.items.isEmpty {
                emptyView
            } else {
                listView
            }
        }
        .onAppear {
            FirebaseAnalytics.logEvent(type: .my_qr_view)
            QRItemService.shared.setObserver { histores in
                viewModel.filteredItems = histores
                viewModel.items = histores
            }
        }
        .hideNavigationBar(isHidden: true)
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $viewModel.showIAP) {
            IAPView(source: .topBar)
        }
    }
    
    // MARK: - ViewBuilder
    @ViewBuilder var emptyView: some View {
        Spacer()
            .frame(height: HEIGHT_SCREEN / 20)
        
        Image(R.image.history_empty_ic.name)
            .aspectRatio(contentMode: .fit)
        
        VStack(spacing: 36) {
            VStack(alignment: .center, spacing: 4) {
                Text(Rlocalizable.artify_your_qr_codes)
                    .font(R.font.beVietnamProSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                
                Text(Rlocalizable.no_qrs_created_yet)
                    .font(R.font.beVietnamProLight.font(size: 16))
                    .foregroundColor(R.color.color_6A758B.color)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                createQRBlock?()
            } label: {
                Text(Rlocalizable.create_qr())
                    .font(R.font.beVietnamProSemiBold.font(size: 14))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.white)
            }
            .frame(width: 156, height: 40)
            .background(R.color.color_653AE4.color)
            .clipShape(Capsule())
        }
        .padding(.horizontal, 40)
        .opacity(1)
        Spacer()
    }
    
    @ViewBuilder var listView: some View {
        HistoryListView(items: $viewModel.filteredItems, isInHistory: true, onDelete: { item in
            if #available(iOS 16.0, *) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.delete(item: item)
                }
            } else {
                viewModel.delete(item: item)
            }
        }, showIAP: {
            viewModel.showIAP.toggle()
        })
    }
}

// MARK: - PreviewProvider
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}

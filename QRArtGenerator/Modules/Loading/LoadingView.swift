//
//  LoadingView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct LoadingView: View {
    
    @State var moveDown: Bool = false
    @State var isShowSub: Bool = false
    @State var index: Int = .zero
    @Environment(\.dismiss) private var dismiss
    
    let listTitle: [String] = [Rlocalizable.analysing_the_qr(),
                               Rlocalizable.applying_the_style(),
                               Rlocalizable.igniting_the_ai_engine(),
                               Rlocalizable.extracting_feature(),
                               Rlocalizable.generating_your_qr()]
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    var onShowSub: BoolBlock? = nil
    
    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .bottom) {
                    LottieView(lottieFile: R.file.qrLoadingJson.name)
                        .offset(CGSize(width: 0, height: -50))
                    Text(listTitle[index])
                        .font(R.font.beVietnamProMedium.font(size: 16))
                        .animation(.easeInOut)
                }
                .frame(width: UIScreen.screenWidth - 180, height: UIScreen.screenWidth - 100)
                LottieView(lottieFile: R.file.magicLoadingJson.name)
            }
            .frame(width: UIScreen.screenWidth + 180, height: UIScreen.screenWidth)
            .padding(.top, 0)
            if !UserDefaults.standard.isUserVip {
                speedUpButton
                    .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onReceive(timer) { _ in
            if index < listTitle.count - 1 {
                index += 1
            } else {
                index = 0
            }
        }
        .fullScreenCover(isPresented: $isShowSub) {
            IAPView(source: .generateButton, onClose: {
                onShowSub?(false)
            })
        }
    }
    
    @ViewBuilder var speedUpButton: some View {
        HStack {
            Button {
                onShowSub?(true)
                isShowSub.toggle()
            } label: {
                Image(R.image.ic_speed_ip)
                Text(Rlocalizable.speed_up)
                    .foregroundColor(R.color.color_FFF500.color)
                    .font(R.font.beVietnamProSemiBold.font(size: 14))
            }
        }
        .frame(width: 236, height: 48)
        .background(R.color.color_653AE4.color)
        .cornerRadius(100)
        .border(radius: 100, color: R.color.color_D8CEF8.color, width: 8)

    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

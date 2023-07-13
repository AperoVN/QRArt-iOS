//
//  AccessPhotoPopup.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 13/07/2023.
//

import SwiftUI

struct AccessPhotoPopup: View {
    var body: some View {
        ZStack {
            Color(.black).opacity(0.45)
            VStack {
                
                
                
//                VStack(spacing: 16) {
//                    R.image.img_success.image
//                    Text(Rlocalizable.photos_access())
//                        .font(R.font.urbanistMedium.font(size: 16))
//                        .foregroundColor(R.color.color_1C1818.color)
//                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
//                        .multilineTextAlignment(.center)
//                }
//                Button {
//                    Router.showHistory()
//                } label: {
//                    Text(Rlocalizable.photos_access_desc())
//                        .font(R.font.urbanistSemiBold.font(size: 16))
//                        .foregroundColor(R.color.color_0F1B2E.color)
//                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//                }
//                    .frame(height: 45)
//                    .frame(maxWidth: .infinity)
//
//                .background(R.color.color_EAEAEA.color)
//                .cornerRadius(45/2)
//                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0))
            .frame(width: WIDTH_SCREEN - 68*2)
            .background(Color.white)
            .cornerRadius(12)
        }
        .ignoresSafeArea()
    }
}

struct AccessPhotoPopup_Previews: PreviewProvider {
    static var previews: some View {
        AccessPhotoPopup()
    }
}

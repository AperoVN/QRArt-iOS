//
//  ResultButtonView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 03/07/2023.
//

import SwiftUI

enum ResultButtonType: CaseIterable {
    case download
    case download4k
    case regenerate
    case share
    case saveAndShare
    
    var image: Image {
        switch self {
        case .download:
            return R.image.ic_download.image
        case .download4k:
            return R.image.ic_download_4k.image
        case .regenerate:
            return R.image.ic_regenerate.image
        case .share:
            return R.image.ic_share_qr.image
        case .saveAndShare:
            return R.image.ic_share_qr.image
        }
    }
    
    var title: String {
        switch self {
        case .download:
            return Rlocalizable.download()
        case .download4k:
            return Rlocalizable.save_as_4k()
        case .regenerate:
            return Rlocalizable.regenerate()
        case .share:
            return Rlocalizable.share_qr()
        case .saveAndShare:
            return Rlocalizable.save_share()
        }
    }
}

struct ResultButtonView: View {
    @State var typeButton: ResultButtonType = .download4k
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button {
            onTap?()
        } label: {
            
            let height: CGFloat = (typeButton == .download4k) ? 52 : 48
            let color: Color = (typeButton != .download4k) ? R.color.color_EAEAEA.color : R.color.color_D8CEF8.color
            let borderWidth: CGFloat = (typeButton != .download4k) ? 1 : 8
            let backgroundColor: Color = (typeButton != .download4k) ? R.color.color_F7F7F7.color : R.color.color_653AE4.color
            
            ZStack(alignment: .topTrailing) {
                HStack(alignment: .center, spacing: 8) {
                    typeButton.image
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(typeButton.title)
                        .foregroundColor((typeButton != .download4k) ? Color.black : Color.white)
                        .font(R.font.beVietnamProSemiBold.font(size: 14))
                }
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(backgroundColor)
                .cornerRadius(height/2)
                .border(radius: height/2,
                        color: color,
                        width: borderWidth)
                if typeButton == .download4k, !UserDefaults.standard.isUserVip {
                    R.image.ic_sub.image
                        .offset(x: -5, y: -5)
                }
            }
        }
    }
}

struct ResultButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ResultButtonView()
    }
}

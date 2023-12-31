//
//  NavibarView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 29/06/2023.
//

import SwiftUI

struct NavibarView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var title: String = "Title" /// Set title
    var isImageTitle: Bool = false /// Ẩn hiện Image cạnh title
    var imageRightTitle: Image = Image(R.image.ic_shine_ai) /// Set Image bên trái title
    var imageRightButton: Image = Image(R.image.ic_purchase) /// Set Image button bên trái
    var isRightButton: Bool = false /// Ẩn hiện button bên trái
    var isLeftButton: Bool = true
    var titleRightButton: String = ""
    var isCloseButton: Bool = false
    
    var onRightAction: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text(title)
                        .font(R.font.urbanistSemiBold.font(size: 18))
                        .lineLimit(1)
                    if isImageTitle {
                        imageRightTitle
                            .frame(width: 28, height: 24)
                            .offset(x: -3, y: -3)
                    }
                }
                .padding(.horizontal, 100)
                HStack(spacing: 0) {
                    if isLeftButton {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            if isCloseButton {
                                Image(R.image.ic_close_screen)
                            } else {
                                Image(R.image.ic_arrow_back)
                            }
                            
                        }.frame(width: 50, height: 50)
                    }

                    Spacer()

                    if isRightButton {
                        Button {
                            onRightAction?()
                        } label: {
                            imageRightButton
                                .scaledToFit()
                        }.frame(width: 50, height: 50)
                    } else {
                        if !titleRightButton.isEmpty  {
                            Text(titleRightButton)
                                .padding(.trailing, 20)
                                .foregroundColor(R.color.color_2073EF.color)
                                .font(R.font.urbanistSemiBold.font(size: 14))
                                .lineLimit(1)
                                .onTapGesture {
                                    onRightAction?()
                                }
                        }
                    }
                }.frame(height: 50)
            }
            
            Color(R.color.color_EAEAEA)
                .frame(height: 1)
        }
    }
}

struct NavibarView_Previews: PreviewProvider {
    static var previews: some View {
        NavibarView()
    }
}

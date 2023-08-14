//
//  ChooseStyleView.swift
//  QRArtGenerator
//
//  Created by khac tao on 02/08/2023.
//

import SwiftUI

struct ChooseStyleView: View {
    @StateObject private var viewModel = ChooseStyleViewModel()
    let cellWidth = (WIDTH_SCREEN-55)/2.0
    @State var templateSelect: Template
    var selectQRBlock: ((Template) -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let spacing: CGFloat = 15
        NavigationView {
            VStack {
                RefreshableScrollView {
                    let count = Float(viewModel.templates.count)/2.0
                    HStack(alignment: .top, spacing: spacing) {
                        VStack {
                            ForEach(0..<Int(count.rounded(.up)), id: \.self) { i in
                                itemView(viewModel.templates[i*2])
                            }
                        }.frame(maxWidth: .infinity)
                        
                        VStack {
                            Spacer().frame(height: 40)
                            ForEach(0..<Int(count.rounded(.down)), id: \.self) { i in
                                itemView(viewModel.templates[i*2+1])
                            }
                        }.frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                }
                .clipped()
                .onAppear {
                    FirebaseAnalytics.logEvent(type: .home_view)
                }
                .toast(message: viewModel.msgError, isShowing: $viewModel.isShowToast, duration: 3)
                .refreshable {
                    viewModel.fetchTemplate()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Rlocalizable.create_qr_title())
            .toolbar {      // navigation bar when create new
                ToolbarItem(placement: .principal) {
                    ZStack(alignment: .center) {
                        HStack {
                            Text(Rlocalizable.create_qr_title)
                                .font(R.font.urbanistSemiBold.font(size: 18))
                                .lineLimit(1)
                            
                            Image(R.image.ic_shine_ai)
                                .frame(width: 28, height: 24)
                                .offset(x: -3, y: -3)
                        }
                        HStack {
                            
                            Image(R.image.ic_close_tl)
                                .padding(.leading, 4)
                                .onTapGesture {
                                    dismiss()
                                }
                            
                            Spacer()
                            
                            Button {
                                if templateSelect.packageType != "basic" && !UserDefaults.standard.isUserVip {
                                    viewModel.isShowIAP.toggle()
                                } else {
                                    selectQRBlock?(templateSelect)
                                    dismiss()
                                }
                            } label: {
                                Text(Rlocalizable.next)
                                    .font(R.font.beVietnamProMedium.font(size: 14))
                                    .foregroundColor(R.color.color_653AE4.color)
                            }
                        }
                        .frame(height: 48)
                    }
                }
            }
            .background(Image(R.image.img_bg.name).resizable().frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea().scaledToFill())
            .fullScreenCover(isPresented: $viewModel.isShowIAP) {
                IAPView(source: .topBar)
            }
          
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
                    .font(R.font.beVietnamProMediumItalic.font(size: 14))
                    .foregroundColor(R.color.color_1B232E.color)
                    .padding(.bottom)
                Spacer()
            }
            if template.packageType != "basic" {
                Image(R.image.ic_style_sub.name)
                    .padding(.top, 13)
                    .padding(.trailing, 11)
            }
        }
        .frame(width: cellWidth, height: cellWidth*4/3)
        .background(Color.white)
        .border(radius: 30, color: (template.key == templateSelect.key ? R.color.color_653AE4.color : Color.clear), width: 2)
        .onTapGesture {
            templateSelect = template
        }
    }
}

struct ChooseStyleView_Previews: PreviewProvider {
    static var previews: some View {
        @State var templateSelect: Template = .init()
        ChooseStyleView(templateSelect: templateSelect)
    }
}
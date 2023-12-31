//
//  DetailStylesView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 01/07/2023.
//

import SwiftUI
import SkeletonUI

struct DetailStylesView: View {
    
    @StateObject private var viewModel = DetailStylesViewModel()
    @State var templates: [Template] = []
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(R.color.color_EAEAEA.color)
                .frame(width: WIDTH_SCREEN, height: 1)
            
            ScrollView {
                LazyVGrid(columns: viewModel.getColumns()) {
                    ForEach(0..<templates.count, id: \.self) { index in
                        let viewModel = CreateQRViewModel(source: .template, templateSelect: templates[index], isPush: true)
                        NavigationLink(destination: CreateQRView(viewModel: viewModel), tag: index, selection: $viewModel.selection) {
                            Button {
                                self.viewModel.selection = index
                                FirebaseAnalytics.logEvent(type: .home_style_click,
                                                           params: [.style: templates[index].name])
                            } label: {
                                itemView(templates[index])
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            
            /// View Ads
            if viewModel.isShowAdsBanner {
                BannerView(adUnitID: .banner_tab_bar, fail: {
                    viewModel.isLoadAdsSuccess = false
                })
                .hiddenConditionally(isHidden: $viewModel.isLoadAdsSuccess)
                .frame(height: 50)
            }
        }
        .navigationTitle(templates.first?.category ?? "")
    }
    
    private func itemView(_ template: Template) -> some View {
        VStack {
            let width = (WIDTH_SCREEN - 64)/3
            AsyncImage(url: URL(string: template.key)) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: width)
                            .cornerRadius(12, antialiased: true)
                    case .empty:
                        EmptyView()
                            .skeleton(with: true, size: CGSize(width: 103, height: 103))
                            .shape(type: .rounded(.radius(8)))
                    default:
                        R.image.img_error.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: width)
                            .cornerRadius(12, antialiased: true)
                }
            }
            Text(template.name)
                .font(R.font.beVietnamProSemiBold.font(size: 12))
                .foregroundColor(R.color.color_1B232E.color)
        }
    }
}

struct DetailStylesView_Previews: PreviewProvider {
    static var previews: some View {
        DetailStylesView()
    }
}

//
//  SearchView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 30/06/2023.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isFocusSearch: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            R.color.color_EAEAEA.color
                .frame(width: WIDTH_SCREEN, height: 1)
                .padding(.top, 14)
            
            if viewModel.searchItems.isEmpty {
                if !viewModel.searchKey.isEmpty {
                    emptyView
                } else {
                    Color.white
                }
            } else {
                listView
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(R.image.search_ic)
                            .frame(width: 24)
                            .padding(.leading, 12)
                        LimitedTextField(placeholder: Rlocalizable.search_qr_name(), value: $viewModel.searchKey, charLimit: 50)
                            .font(R.font.beVietnamProRegular.font(size: 14))
                            .foregroundColor(R.color.color_1B232E.color)
                            .focused($isFocusSearch)
                            .padding(.trailing, 12)
                    }
                    .frame(height: 40)
                    .overlay (
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(R.color.color_EAEAEA.color)
                    )
                    
                    Button(Rlocalizable.cancel()) {
                        isFocusSearch = false
                        dismiss()
                    }
                    .font(R.font.beVietnamProMedium.font(size: 14))
                }
                .frame(height: 48)
            }
        }
        .onAppear {
            if viewModel.isCheckFocusSearch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    let viewController = UIApplication.shared.keyWindow?.rootViewController
                    if let textField = AppHelper.findTextField(in: viewController?.view) {
                        textField.becomeFirstResponder()
                    }
                }
                isFocusSearch = viewModel.isCheckFocusSearch
            }
            QRItemService.shared.setObserver { histores in
                viewModel.searchItems = histores
            }
        }
        .onDisappear {
            isFocusSearch = false
            viewModel.isCheckFocusSearch = false
        }
    }
    
    @ViewBuilder var emptyView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 28) {
                Image(R.image.search_empty_ic)
                
                Text(Rlocalizable.no_qr_found())
                    .font(R.font.beVietnamProSemiBold.font(size: 17))
                    .foregroundColor(R.color.color_0F1B2E.color)
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder var listView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(countText)
                .font(R.font.beVietnamProRegular.font(size: 12))
                .foregroundColor(R.color.color_77778E.color)
            
            HistoryListView(items: $viewModel.searchItems, isInHistory: false, onDelete: nil)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
    }
    
    var countText: String {
        return "\(viewModel.searchItems.count) " + (viewModel.searchItems.count > 1 ? Rlocalizable.results() : Rlocalizable.result())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

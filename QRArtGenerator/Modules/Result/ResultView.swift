//
//  ResultView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI
import ScreenshotPreventing

enum ResultViewSource {
    case history
    case create
}

struct ResultView: View {
    @StateObject var viewModel: ResultViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if !viewModel.isCreate {
            contentView
        } else {
            ZStack {
                NavigationView {
                    contentView
                }
                
                if viewModel.isShowSuccessView {
                    SuccessView()
                }
            }
        }
    }
    
    @ViewBuilder var contentView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
              
                
                viewModel.image
                    .resizable()
                    .cornerRadius(24)
                    .frame(width: WIDTH_SCREEN-40)
                    .aspectRatio(1.0, contentMode: .fit)

                    
                HStack {
                    if viewModel.isCreate {
                        download4kButton
                    } else {
                        saveAndShareButton
                        download4kButton
                    }
                }
                Spacer()
                if viewModel.isShowAdsInter, ReachabilityManager.isNetworkConnected() {
                    AdNativeView(adUnitID: .native_result, type: .medium)
                        .frame(height: 171)
                        .padding(.horizontal, 20)
                }
            }
            .screenshotProtected(isProtected: true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        if viewModel.isCreate {
                            Image(R.image.ic_close_screen)
                                .padding(.leading, 4)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                        Spacer()
                        HStack {
                            Text(viewModel.isCreate ? Rlocalizable.create_qr_title() : Rlocalizable.create_qr())
                                .font(R.font.urbanistSemiBold.font(size: 18))
                                .lineLimit(1)
                            
                            if viewModel.isCreate {
                                Image(R.image.ic_shine_ai)
                                    .frame(width: 28, height: 24)
                                    .offset(x: -3, y: -3)
                            }
                        }
                        
                        Spacer()
                        
                        Button(viewModel.isCreate ? Rlocalizable.done() : "") {
                            FirebaseAnalytics.logEvent(type: .qr_creation_done_click)
                            viewModel.isCreate ? viewModel.save() : ()
                        }
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .frame(width: 33)
                    }
                    .frame(height: 48)
                }
            }
            .fullScreenCover(isPresented: $viewModel.sheet, content: {
                ShareSheet(items: [viewModel.item.qrImage])
            })
            .fullScreenCover(isPresented: $viewModel.showIAP) {
                IAPView(source: .download4K)
            }
            .fullScreenCover(isPresented: $viewModel.isShowLoadingView) {
                LoadingView()
            }
            .toast(message: viewModel.toastMessage, isShowing: $viewModel.isShowToast, duration: 3, position: .center)
            
            if viewModel.showPopupAcessPhoto {
                AccessPhotoPopup {
                    viewModel.dissmissPopupAcessPhoto()
                } onTapCancel: {
                    viewModel.dissmissPopupAcessPhoto()
                }
                .padding(.all, 0)
            }
            Rectangle()
                .fill(R.color.color_EAEAEA.color)
                .frame(width: WIDTH_SCREEN, height: 1)
        }
        .padding(20)
        .onAppear {
            FirebaseAnalytics.logEvent(type: .qr_creation_result_view, params: [.style: viewModel.item.templateQRName,
                                                                                .qr_type: viewModel.item.type.title,
                                                                                .guidance_number: "\(viewModel.item.guidance)",
                                                                                .step_number: "\(viewModel.item.steps)"])
        }
    }
    
    @ViewBuilder var shareButton: some View {
        ResultButtonView(typeButton: .share, isCreate: false) {
            viewModel.share()
        }
    }
    
    @ViewBuilder var regenerateButton: some View {
        ResultButtonView(typeButton: .regenerate) {
            FirebaseAnalytics.logEvent(type: .qr_creation_regenerate_click)
            viewModel.showAdsInter()
        }
    }
    
    @ViewBuilder var downloadButton: some View {
        ResultButtonView(typeButton: .download, onTap: {
            viewModel.checkDownload()
        })
    }
    
    @ViewBuilder var download4kButton: some View {
        ResultButtonView(typeButton: .download4k, isCreate: viewModel.isCreate, onTap: {
            FirebaseAnalytics.logEvent(type: .qr_creation_download_4k_click)
            if !UserDefaults.standard.isUserVip {
                viewModel.showIAP.toggle()
            } else {
                viewModel.checkDownload4K()
            }
        })
    }
    
    @ViewBuilder var saveAndShareButton: some View {
        ResultButtonView(typeButton: .saveAndShare) {
            FirebaseAnalytics.logEvent(type: .qr_creation_save_share_click)
            viewModel.saveAndShare()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(viewModel: ResultViewModel(item: QRDetailItem(), image: Image(""), source: .create))
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct TransparentBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

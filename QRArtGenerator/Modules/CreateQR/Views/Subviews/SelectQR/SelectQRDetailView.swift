//
//  SelectQRView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct SelectQRDetailView: View {
    @State var name: String = ""
    @State var rotate: Double = 0
    @Binding var showingSelectQRTypeView: Bool
    @Binding var showingSelectCountryView: Bool
    @Binding var validInput: Bool
    @Binding var input: QRDetailItem
    @Binding var countrySelect: Country
    var focusTextfieldType: FocusState<TextFieldType?>.Binding
    
    var type: QRType
    
    var body: some View {
        VStack (spacing: 16) {
            VStack(alignment: .leading) {
                Text(Rlocalizable.select_qr_type)
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                HStack(alignment: .center, spacing: 12) {
                    type.image
                        .shadow(color: type.shadowColor, radius: type.radiusShadow, x: type.positionShadow.x, y: type.positionShadow.y)
                    Text(type.title)
                        .font(R.font.urbanistMedium.font(size: 16))
                        .foregroundColor(R.color.color_1B232E.color)
                    Spacer()
                    imageDropDown.rotationEffect(.degrees(rotate))
                }
                .background(Color.white)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    showingSelectQRTypeView = true
                    withAnimation(.linear(duration: 0.1)) {
                        rotate = 90
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        rotate = 0
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .frame(maxHeight: 44)
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                VStack(spacing: 12) {
                    InputTextView(title: Rlocalizable.name(),
                                  placeholder: Rlocalizable.enter_qr_name(),
                                  name: $input.name,
                                  validInput: $validInput,
                                  focusField: focusTextfieldType,
                                  textfieldType: .name)
                    switch type {
                    case .website:
                        InputTextView(title: Rlocalizable.website_link(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      type: .url, name: $input.urlString,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .link)
                    case .contact:
                        InputTextView(title: Rlocalizable.contact_name(),
                                      placeholder: Rlocalizable.enter_contact_name(),
                                      name: $input.contactName,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .contactName)
                        InputPhoneNumberView(type: type,
                                             phoneNumber: $input.phoneNumber,
                                             showingSelectCountryView: $showingSelectCountryView,
                                             validInput: $validInput,
                                             country: $countrySelect,
                                             focusField: focusTextfieldType,
                                             textfieldType: .contactPhone)
                    case .text:
                        InputTextView(title: Rlocalizable.text(),
                                      placeholder: Rlocalizable.enter_text_here(),
                                      name: $input.text,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .text)
                    case .email:
                        InputEmailView(title: Rlocalizable.email_to(),
                                      placeholder: "Example@gmail.com",
                                      name: $input.emailAddress,
                                      validInput: $validInput,
                                       focusField: focusTextfieldType,
                                       textfieldType: .email)
                        InputTextView(title: Rlocalizable.subject(),
                                      placeholder: Rlocalizable.enter_subject(),
                                      name: $input.emailSubject,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .emailSubject)
                        DescriptionView(title: Rlocalizable.email_desc(),
                                        placeHolder: Rlocalizable.enter_desc(),
                                        desc: $input.emailDescription,
                                        validInput: $validInput,
                                        focusField: focusTextfieldType,
                                        textfieldType: .emailDesc)
                    case .whatsapp:
                        InputPhoneNumberView(type: type,
                                             phoneNumber: $input.phoneNumber,
                                             showingSelectCountryView: $showingSelectCountryView,
                                             validInput: $validInput,
                                             country: $countrySelect,
                                             focusField: focusTextfieldType,
                                             textfieldType: .contactPhone)
                    case .instagram:
                        InputTextView(title: Rlocalizable.instagram_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      type: .url, name: $input.urlString,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .link)
                    case .facebook:
                        InputTextView(title: Rlocalizable.facebook_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      type: .url, name: $input.urlString,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .link)
                    case .twitter:
                        InputTextView(title: Rlocalizable.twitter_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      type: .url, name: $input.urlString,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .link)
                    case .spotify:
                        InputTextView(title: Rlocalizable.spotify_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      type: .url, name: $input.urlString,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .link)
                    case .youtube:
                        InputTextView(title: Rlocalizable.youtube_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      type: .url, name: $input.urlString,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .link)
                    case .wifi:
                        InputTextView(title: Rlocalizable.ssid(),
                                      placeholder: Rlocalizable.enter_wifi_name(),
                                      name: $input.wfSsid, validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .wifiID)
                        InputTextView(title: Rlocalizable.password(),
                                      placeholder: Rlocalizable.enter_password(),
                                      name: $input.wfPassword, validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .wifiPass)
                        SecurityModeView(wifiModeSelect: $input.indexWfSecurityMode)
                    case .paypal:
                        InputTextView(title: Rlocalizable.paypal_url(),
                                      placeholder: "https://paypal.me/",
                                      type: .url, name: $input.urlString,
                                      validInput: $validInput,
                                      focusField: focusTextfieldType,
                                      textfieldType: .link)
                        AmountView(amount: $input.paypalAmount,
                                   validInput: $validInput,
                                   focusField: focusTextfieldType,
                                   textfieldType: .paypal)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder var imageDropDown: some View {
        Image(R.image.ic_left)
    }
}

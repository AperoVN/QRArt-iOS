//
//  InputEmailView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 08/07/2023.
//

import SwiftUI

struct InputEmailView: View {
    var title: String = ""
    var placeholder: String = ""
    @Binding var name: String
    @Binding var validInput: Bool
    var focusField: FocusState<TextFieldType?>.Binding
    var textfieldType: TextFieldType
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
            textField
            if validInput && name.isEmptyOrWhitespace() {
                Text(Rlocalizable.cannot_be_empty)
                    .foregroundColor(R.color.color_BD1E1E.color)
                    .font(R.font.beVietnamProRegular.font(size: 14))
            } else if validInput && !name.isValidEmail() {
                Text(Rlocalizable.valid_email)
                    .foregroundColor(R.color.color_BD1E1E.color)
                    .font(R.font.beVietnamProRegular.font(size: 14))
            }
        }
    }
    
    @ViewBuilder var textField: some View {
        ZStack(alignment: .leading) {
            if name.isEmpty {
                Text(placeholder)
                    .foregroundColor(R.color.color_6A758B.color)
                    .font(R.font.beVietnamProRegular.font(size: 14))
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            }
            TextField("", text: $name)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .frame(maxHeight: 42)
                .focused(focusField, equals: textfieldType)
                .border(radius: 12, color: getBorderColor(),
                        width: 1)
                .font(R.font.beVietnamProRegular.font(size: 14))
                .foregroundColor(R.color.color_1B232E.color)
                .onChange(of: name) { newValue in
                    if newValue.count > 50 {
                        name = String(newValue.prefix(50))
                    }
                }
        }
    }
    
    func getBorderColor() -> Color {
        if validInput && (name.isEmptyOrWhitespace() || !name.isValidEmail()) {
            return R.color.color_BD1E1E.color
        } else {
            if focusField.wrappedValue == textfieldType {
                return R.color.color_653AE4.color
            } else {
                return R.color.color_EAEAEA.color
            }
        }
    }
}

struct InputEmailView_Previews: PreviewProvider {
    @FocusState static var focusState: TextFieldType?
    
    static var previews: some View {
        InputEmailView(name: .constant(""), validInput: .constant(false), focusField: $focusState,
                       textfieldType: .email)
    }
}

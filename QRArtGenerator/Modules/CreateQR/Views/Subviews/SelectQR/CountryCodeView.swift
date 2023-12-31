//
//  CountryCodeView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import SwiftUI

struct CountryCodeView: View {
    
    var country: Country
    @Binding var selectedCountry: Country
    
    var isSelected: Bool {
        selectedCountry == country
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                Image(R.image.ic_checked)
                    .opacity(isSelected ? 1 : 0)
                Text("\(country.name) (\(country.dialCode))")
                    .font(R.font.beVietnamProMedium.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                Spacer()
                Text(country.flag)
                    .frame(width: 24, height: 24)
                    .font(R.font.beVietnamProRegular.font(size: 24))
                    .multilineTextAlignment(.center)
            }
            .frame(maxHeight: 52)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .background(Color.white)
            .onTapGesture {
                if !isSelected {
                    selectedCountry = country
                }
                UIApplication.shared.endEditing()
            }
            
            R.color.color_EAEAEA.color.frame(height: 1)
        }

    }
}

struct CountryCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodeView(country: Country(flag: String.emojiFlag(for: "US"), code: "+93", dialCode: "AF"), selectedCountry: .constant(Country(flag: "1", code: "+93", dialCode: "AF")))
    }
}

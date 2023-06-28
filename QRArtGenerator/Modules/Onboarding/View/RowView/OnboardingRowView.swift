//
//  OnboardingRowView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 28/06/2023.
//

import SwiftUI

struct OnboardingRowView: View {
    
    let model: OnboardingModel
    
    var body: some View {
            VStack(alignment: .center, spacing: 12) {
                model.image?
                    .resizable()
                    .scaledToFit()
                Text(model.title ?? "")
                    .font(R.font.urbanistBold.font(size: 18))
                    .foregroundColor(R.color.color_1B232E.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                Text(model.content ?? "")
                    .font(R.font.urbanistRegular.font(size: 16))
                    .foregroundColor(R.color.color_6A758B.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

struct OnboardingRowView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRowView(model: OnboardingModel.example)
    }
}

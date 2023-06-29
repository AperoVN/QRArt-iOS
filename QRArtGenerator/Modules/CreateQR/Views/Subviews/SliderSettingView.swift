//
//  SliderSettingView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI

struct SliderSettingView: View {
    var title: String = ""
    var desc: String = ""
    @State private var value: Double = 0
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistSemiBold.font(size: 14))
            Text(desc)
                .foregroundColor(R.color.color_6A758B.color)
                .font(R.font.urbanistMedium.font(size: 12))
            HStack(spacing: 8) {
                Slider(value: $value, in: 0...8)
                    .setColorSlider(color: R.color.color_653AE4.color)
                Text("\(Int(value))")
                    .font(R.font.urbanistSemiBold.font(size: 14))
                    .foregroundColor(R.color.color_1B232E.color)
            }
            
        }
    }
}

struct SliderSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SliderSettingView()
    }
}

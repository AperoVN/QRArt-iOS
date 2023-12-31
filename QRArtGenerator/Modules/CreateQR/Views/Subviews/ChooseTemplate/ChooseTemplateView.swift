//
//  ChooseTemplateView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct ChooseTemplateView: View {
    @Binding var templates: [Template]
    @Binding var indexSelectStyle: Int?
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text(Rlocalizable.choose_a_template())
                    .font(R.font.beVietnamProSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                    .padding(.leading, 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<templates.count, id: \.self) { index in
                            ItemTemplateView(template: $templates[index], index: index)
                                .onTapGesture {
                                    if index != indexSelectStyle {
                                        indexSelectStyle = index
                                    }
                                }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                
            }
            
            .frame(maxWidth: WIDTH_SCREEN, maxHeight: 193)
        }
    }
}

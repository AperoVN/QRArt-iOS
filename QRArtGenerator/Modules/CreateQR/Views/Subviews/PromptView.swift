//
//  PromptView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI

struct PromptView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Rlocalizable.prompt())
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .foregroundColor(R.color.color_1B232E.color)
                    Text(Rlocalizable.prompt_desc())
                        .font(R.font.urbanistMedium.font(size: 12))
                        .foregroundColor(R.color.color_6A758B.color)
                }
                Spacer()
                R.image.ic_pen.image
            }
            TextField(Rlocalizable.enter_prompt(), text: $text)
                .frame(height: 100, alignment: .top)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                .font(R.font.urbanistRegular.font(size: 14))
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView()
    }
}
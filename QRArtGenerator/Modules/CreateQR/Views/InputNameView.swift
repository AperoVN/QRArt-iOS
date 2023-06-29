//
//  InputNameView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI

struct InputNameView: View {
    var title: String = "Name"
    var placeholder: String = "Input your Name"
    @State var name: String = ""
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            TextField(placeholder, text: $name)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .frame(maxHeight: 42)
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
        }
    }
}

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        InputNameView()
            .previewLayout(.sizeThatFits)
    }
}

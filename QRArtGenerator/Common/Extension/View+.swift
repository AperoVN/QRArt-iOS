//
//  View+.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI
import UIKit

extension View {
    @ViewBuilder func hideNavigationBar() -> some View {
        if #available(iOS 16, *) {
            toolbar(.hidden)
        } else {
            navigationBarHidden(true)
        }
    }
    
    @ViewBuilder func border(radius: CGFloat, color: Color, width: CGFloat) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius)
                .inset(by: 1)
                .stroke(color, lineWidth: width))
        .cornerRadius(radius)
    }
    
    @ViewBuilder func clearBackgroundColorList() -> some View {
        if #available(iOS 16, *) {
            scrollContentBackground(.hidden)
        }
    }
    
    @ViewBuilder func hideSeparatorLine() -> some View {
        if #available(iOS 15, *) {
            listRowSeparator(.hidden)
        }
    }
    
    @ViewBuilder func setColorSlider(color: Color) -> some View {
        if #available(iOS 16, *) {
            tint(color)
        } else {
            accentColor(color)
        }
    }
    
    @ViewBuilder func disableScroll() -> some View {
        if #available(iOS 16, *) {
            scrollDisabled(true)
        } else {
            onAppear {
                UITableView.appearance().isScrollEnabled = false
            }
        }
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

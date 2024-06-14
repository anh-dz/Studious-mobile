//
//  ViewModel.swift
//  Studious
//
//  Created by Alex on 6/12/24.
//

import SwiftUI

struct VerticalBarView: View {
    var barColor: Color
    var cornerRadius: CGFloat
    var markDetails: BarItem

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { g in
                VStack {
                   Text("\(Int(self.markDetails.value))")
                        .font(.caption)
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .foregroundColor(self.barColor)
                        .frame(width: g.size.width * 0.45, height: (g.size.height * 0.8) * (CGFloat(self.markDetails.value) / 24))
                        .scaleEffect(y: -1) // Invert the rectangle vertically
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom) // Align the VStack to the bottom
            }
            Text(self.markDetails.name)
                .font(.footnote)
                .padding(.horizontal, 2.0)
                .rotationEffect(.degrees(330))
        }
    }
}

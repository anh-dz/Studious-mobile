//
//  ViewModel.swift
//  Studious
//
//  Created by Alex on 6/12/24.
//

import SwiftUI

struct BarChartView: View {
    var barChartColor: Color
    var barColor: Color
    var barStyle: BarStyle
    var data: [BarItem]
    
    init(data: [BarItem], barChartColor: Color? = nil, barColor: Color? = nil, barStyle: BarStyle? = nil) {
        self.data = data
        self.barChartColor = barChartColor ?? Color.red
        self.barColor = barColor ?? Color.black
        self.barStyle = barStyle ?? BarStyle.round
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(barChartColor.opacity(0.25))
                HStack(spacing: 0) {
                    ForEach((data)) { item in
                        VerticalBarView(barColor: self.barColor, cornerRadius: CGFloat(20 * self.barStyle.rawValue), markDetails: item)
                            .animation(.spring())
                    }
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom) // Align the HStack to the bottom
        }
    }
}

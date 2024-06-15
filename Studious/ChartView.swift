//
//  ChartView.swift
//  Studious
//
//  Created by Alex on 6/12/24.
//

import SwiftUI

struct BarItem: Identifiable {
    var id = UUID()
    var name: String
    var value: Double
}

enum BarStyle: Int {
    case rect
    case round
}

struct ChartView: View {
    var w: Int
    var b: Int
    
    @State var dataWeek: [BarItem] = [BarItem(name: "Sun", value: 1), BarItem(name: "Mon", value: 2), BarItem(name: "Tue", value: 6), BarItem(name: "Wed", value: 4), BarItem(name: "Fri", value: 10), BarItem(name: "Sat", value: 10)]
    
    @State var dataSubject: [ChartCellModel] = [ChartCellModel(color: Color.blue, value: 10, name: "Math"),
    ChartCellModel(color: Color.yellow, value: 20, name: "Physics"),
    ChartCellModel(color: Color.pink, value: 50, name: "Chemistry")]
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Thống kê")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    CircleBar(workSessions: w, breakSessions: b)
                }
                .padding()
                
                HStack {
                    BarChartView(data: dataWeek, barChartColor: Color.red, barColor: Color.black, barStyle: .rect)
                            .frame(height: 180)
                }
                .padding()
                
                HStack {
                    PieChartView(sample: dataSubject)
                }
                .padding()
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(w: 5, b: 3)
    }
}

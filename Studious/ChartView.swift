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
    var workSessions: Int
    var breakSessions: Int
    
    @State var pickerSelection = 0
    @State var styleSelection = 0
    @State var colorSelection = 0
    @State var marks: [BarItem] = [BarItem(name: "Sun", value: 1), BarItem(name: "Mon", value: 2), BarItem(name: "Tue", value: 6), BarItem(name: "Wed", value: 4), BarItem(name: "Fri", value: 10), BarItem(name: "Sat", value: 10)]
    
    var body: some View {
        VStack {
            Text("Thống kê")
                .font(.largeTitle)
                .padding()
            
            HStack {
                VStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(workSessions) / CGFloat(workSessions + breakSessions))
                        .stroke(Color.green, lineWidth: 20)
                        .frame(width: 150, height: 150)
                    Text("Work: \(workSessions)")
                        .foregroundColor(.green)
                        .padding()
                }
                
                VStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(breakSessions) / CGFloat(workSessions + breakSessions))
                        .stroke(Color.blue, lineWidth: 20)
                        .frame(width: 150, height: 150)
                    Text("Break: \(breakSessions)")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
            
            HStack {
                BarChartView(data: marks, barChartColor: Color.red, barColor: Color.black, barStyle: .rect)
                        .frame(height: 200)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(workSessions: 5, breakSessions: 3)
    }
}

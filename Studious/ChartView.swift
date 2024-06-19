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
    var value: Float
}

enum BarStyle: Int {
    case rect
    case round
}

struct ChartView: View {
    var w: Int
    var b: Int
    
    @State var dataWeek: [BarItem] = []
    
    @State var dataSubject: [ChartCellModel] = []
    
    private let color: [Color] = [Color.blue, Color.green, Color.yellow, Color.pink, Color.black, Color.purple, Color.gray]
    
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
        .onAppear {
            fetchBarData()
            fetchPieData()
        }
    }
    
    private func fetchPieData() {
        let url = URL(string: "http://127.0.0.1:5000/get_sum_data")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received from server")
                return
            }
            
            do {
                let fetchedData = try JSONDecoder().decode([String: Float].self, from: data)
                let myChartData = fetchedData.map { chartData(name: $0.key, value: $0.value) }
                updatePieChart(with: myChartData)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func updatePieChart(with fetchedData: [chartData]) {
        for (index, data) in fetchedData.enumerated() {
            dataSubject.append(ChartCellModel(color: color[index], name: data.name, value: CGFloat(data.value)))
        }
    }
    
    private func fetchBarData() {
        let url = URL(string: "http://127.0.0.1:5000/get_time")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received from server")
                return
            }

            do {
                let fetchedData = try JSONDecoder().decode([String: Float].self, from: data)
                
                let myChartData = fetchedData.map { chartData(name: $0.key, value: $0.value) }
                
                updateBarChart(with: myChartData)
                
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func updateBarChart(with fetchedData: [chartData]) {
        for data in fetchedData {
            print("\(data.name): \(data.value)")
            dataWeek.append(BarItem(name: data.name, value: data.value))
        }
    }
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(w: 5, b: 3)
    }
}

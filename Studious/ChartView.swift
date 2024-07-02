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
        DataService.shared.fetchPieData { result in
            switch result {
            case .success(let fetchedData):
                let myChartData = fetchedData.map { ChartData(name: $0.name, value: $0.value) }
                updatePieChart(with: myChartData)
            case .failure(let error):
                print("Error fetching pie data: \(error.localizedDescription)")
            }
        }
    }
    
    private func updatePieChart(with fetchedData: [ChartData]) {
        for (index, data) in fetchedData.enumerated() {
            dataSubject.append(ChartCellModel(color: color[index], name: data.name, value: CGFloat(data.value)))
        }
    }
    
    private func fetchBarData() {
        DataService.shared.fetchBarData { result in
            switch result {
            case .success(let fetchedData):
                let myChartData = fetchedData.map { ChartData(name: $0.name, value: $0.value) }
                updateBarChart(with: myChartData)
            case .failure(let error):
                print("Error fetching bar data: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateBarChart(with fetchedData: [ChartData]) {
        for data in fetchedData {
            dataWeek.append(BarItem(name: data.name, value: data.value))
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(w: 5, b: 3)
    }
}

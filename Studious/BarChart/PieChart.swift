import SwiftUI

struct PieChartCell: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: (rect.origin.x + rect.width) / 2, y: (rect.origin.y + rect.height) / 2)
        let radii = min(center.x, center.y)
        var path = Path()
        path.addArc(center: center, radius: radii, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        return path
    }
}

struct PieChart: View {
    @State private var selectedCell: UUID = UUID()
    
    let dataModel: ChartDataModel
    let onTap: (ChartCellModel?) -> ()
    
    var body: some View {
        ZStack {
            ForEach(dataModel.chartCellModel) { dataSet in
                PieChartCell(startAngle: dataSet.startAngle, endAngle: dataSet.endAngle)
                    .foregroundColor(dataSet.color)
                    .onTapGesture {
                        withAnimation {
                            if self.selectedCell == dataSet.id {
                                self.onTap(nil)
                                self.selectedCell = UUID()
                            } else {
                                self.selectedCell = dataSet.id
                                self.onTap(dataSet)
                            }
                        }
                    }
                    .scaleEffect((self.selectedCell == dataSet.id) ? 1.05 : 1.0)
            }
        }
    }
}

struct ChartCellModel: Identifiable {
    let id = UUID()
    let color: Color
    let value: CGFloat
    let name: String
    var startAngle: Angle = .zero
    var endAngle: Angle = .zero
}

final class ChartDataModel: ObservableObject {
    var chartCellModel: [ChartCellModel]
    
    init(dataModel: [ChartCellModel]) {
        self.chartCellModel = dataModel
        self.calculateAngles()
    }
    
    var totalValue: CGFloat {
        chartCellModel.reduce(CGFloat(0)) { $0 + $1.value }
    }
    
    func calculateAngles() {
        var currentAngle: Angle = .degrees(0)
        
        for index in chartCellModel.indices {
            let dataSet = chartCellModel[index]
            let angleIncrement = Angle(degrees: Double(dataSet.value / totalValue) * 360)
            chartCellModel[index].startAngle = currentAngle
            currentAngle += angleIncrement
            chartCellModel[index].endAngle = currentAngle
        }
    }
}

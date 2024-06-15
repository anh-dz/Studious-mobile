//
//  PieChartView.swift
//  Studious
//
//  Created by Alex on 6/15/24.
//

import SwiftUI

struct PieChartView: View {
    @State var selectedPie: String = "Biểu đồ thời gian học từng môn"
    
    var sample: [ChartCellModel]
    
    var body: some View {
        ScrollView {
            VStack {
                HStack() {
                    PieChart(dataModel: ChartDataModel.init(dataModel: sample), onTap: {
                        dataModel in
                        if let dataModel = dataModel {
                            self.selectedPie = "Môn học: \(dataModel.name)\nThời gian: \(Int(dataModel.value)) giờ"
                        } else {
                            self.selectedPie = "Biểu đồ thời gian học từng môn"
                        }
                    })
                    .frame(width: 250, height: 250, alignment: .center)
                    .padding()
                    Text(selectedPie)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    }
                HStack {
                    ForEach(sample) { dataSet in
                        VStack {
                            Circle()
                                .foregroundColor(dataSet.color)
                            Text(dataSet.name)
                                .font(.footnote)
                        }
                    }
                }
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = [ChartCellModel(color: Color.blue, value: 10, name: "Math"),
                      ChartCellModel(color: Color.yellow, value: 20, name: "Physics"),
                      ChartCellModel(color: Color.pink, value: 50, name: "Chemistry")]
        
        PieChartView(sample: sample)
    }
}

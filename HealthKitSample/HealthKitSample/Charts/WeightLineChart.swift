//
//  WeightLineChart.swift
//  HealthKitSample
//
//  Created by Justin on 6/19/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var chartData: [DateValueChartData]
    
    var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var averageWeight: Double {
        chartData.map { $0.value }.average
    }
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var body: some View {
        let config = ChartContainerConfiguration(title: "Weights",
                                                 symbol: "figure",
                                                 subtitle: "Avg: \(averageWeight.formatted(.number.precision(.fractionLength(1)))) lbs",
                                                 context: .weight,
                                                 isNav: true)
        
        ChartContainer(config: config) {
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.xyaxis.line", title: "No Data", description: "There is no weight data from the Health App")
            } else {
                Chart {
                    if let selectedData {
                        ChartAnnotationView(data: selectedData, context: .weight)
                    }
                    
                    RuleMark(y: .value("Goal", 155))
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                    
                    ForEach(chartData) { weight in
                        
                        AreaMark(
                            x: .value("Day", weight.date, unit: .day),
                            yStart: .value("Value", weight.value),
                            yEnd: .value("Min Value", minValue)
                        )
                        .foregroundStyle(Gradient(colors: [.indigo.opacity(0.5), .clear]))
                        
                        LineMark(x: .value("Day", weight.date, unit: .day), y: .value("Value", weight.value))
                            .foregroundStyle(.indigo)
                            .interpolationMethod(.catmullRom)
                            .symbol(.circle)
                    }
                }
                .frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartYScale(domain: .automatic(includesZero: false))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(Color.secondary.opacity(0.3))
                        
                        AxisValueLabel()
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                selectedDay = newValue
            }
        }
    }
}

#Preview {
    WeightLineChart(chartData: ChartHelper.convert(data: MockData.weightData))
}

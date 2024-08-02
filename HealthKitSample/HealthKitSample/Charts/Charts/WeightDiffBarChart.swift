//
//  WeightBarChart.swift
//  HealthKitSample
//
//  Created by Justin on 6/20/24.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var chartData: [DateValueChartData]
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var body: some View {
        ChartContainer(chartType: .weightDiffBar) {
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.bar", title: "No Data", description: "There is no weight data from the Health App")
            } else {
                Chart {
                    if let selectedData {
                        ChartAnnotationView(data: selectedData, context: .weight)
                    }
                    
                    ForEach(chartData) { weights in
                        Plot {
                            BarMark(x: .value("Date", weights.date, unit: .day), y: .value("Average Weight Change", weights.value))
                                .foregroundStyle(weights.value < 0 ? Color.mint.gradient : Color.indigo.gradient)
                            .opacity(rawSelectedDate == nil || weights.date == selectedData?.date ? 1.0 : 0.3)
                        }
                        .accessibilityLabel(weights.date.accessibilityDate)
                        .accessibilityValue("\(weights.value.formatted(.number.precision(.fractionLength(1)).sign(strategy: .always()))) pounds")
                    }
                }
                .frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) {
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
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
    WeightDiffBarChart(chartData: ChartHelper.averageDailyWeightDiffs(for: []))
}

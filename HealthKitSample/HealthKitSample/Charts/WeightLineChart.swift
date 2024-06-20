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
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return chartData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date )}
    }
    
    var avgStepCount: Double {
        guard !chartData.isEmpty else { return 0 }
        let totalSteps = chartData.reduce(0) { $0 + $1.value }
        
        return totalSteps / Double(chartData.count)
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Avg: 180 lbs")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weight in
                    AreaMark(x: .value("Day", weight.date, unit: .day), y: .value("Value", weight.value))
                        .foregroundStyle(Gradient(colors: [.blue.opacity(0.5), .clear]))
                    
                    LineMark(x: .value("Day", weight.date, unit: .day), y: .value("Value", weight.value))
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChart(selectedStat: .steps, chartData: MockData.weightData)
}

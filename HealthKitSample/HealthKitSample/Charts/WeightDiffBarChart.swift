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
    var chartData: [WeekdayChartData]
    
    var selectedData: WeekdayChartData? {
        guard let rawSelectedDate else { return nil }
        return chartData.first { Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date )}
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Label("Average Weight Change", systemImage: "figure.walk")
                        .font(.title3.bold())
                        .foregroundStyle(.indigo)
                    
                    Text("Per Weekday (Last 28 Days)")
                        .font(.caption)
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                if let selectedData {
                    RuleMark(x: .value("Selected Metric", selectedData.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .offset(y: -10)
                        .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                            annotationView
                        }
                }
                
                ForEach(chartData) { weights in
                    BarMark(x: .value("Date", weights.date, unit: .day), y: .value("Average Weight Change", weights.value))
                        .foregroundStyle(weights.value < 0 ? Color.mint.gradient : Color.indigo.gradient)
                        .opacity(rawSelectedDate == nil || weights.date == selectedData?.date ? 1.0 : 0.3)
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
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedData?.date ?? .now, format: .dateTime.weekday(.wide))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedData?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(selectedData?.value ?? 0 < 0 ? .mint : .indigo)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    WeightDiffBarChart(chartData: ChartMath.averageDailyWeightDiffs(for: MockData.weightData))
}

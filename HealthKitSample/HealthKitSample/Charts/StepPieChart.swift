//
//  StepPieChart.swift
//  HealthKitSample
//
//  Created by Justin on 6/18/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    
    var chartData: [WeekdayChartData] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Label("Averages", systemImage: "calendar")
                    .font(.title3.bold())
                    .foregroundStyle(.pink)
                
                Text("Last 28 Days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weekday in
                    SectorMark(angle: .value("Average Steps", weekday.value), innerRadius: .ratio(0.618), angularInset: 1)
                        .foregroundStyle(.pink.gradient)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            Text(weekday.value, format: .number.precision(.fractionLength(0)))
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                        }
                }
            }
            .frame(height: 240)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: HealthMetric.mockData))
}

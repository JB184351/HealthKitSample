//
//  ChartContainer.swift
//  HealthKitSample
//
//  Created by Justin on 7/8/24.
//

import SwiftUI

enum ChartType {
    case stepBar(average: Int)
    case stepWeekdayPie
    case weightLine(average: Double)
    case weightDiffBar
}

struct ChartContainer<Content: View>: View {
    let chartType: ChartType
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            if isNav {
                navgiationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        
    }
    
    var navgiationLinkView: some View {
        NavigationLink(value: context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
        .accessibilityHint("Tap for data in list view")
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)
            
            Text(subTitle)
                .font(.caption)
        }
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityElement(children: .ignore)
    }
    
    var isNav: Bool {
        switch chartType {
        case .stepBar(_), .weightLine(_):
            return true
        case .stepWeekdayPie:
            return false
        case .weightDiffBar:
            return false
        }
    }
    
    var context: HealthMetricContext {
        switch chartType {
        case .stepBar(_), .stepWeekdayPie:
                .steps
        case .weightLine(_), .weightDiffBar:
                .weight
        }
    }
    
    var title: String {
        switch chartType {
        case .stepBar(let average):
            "Steps"
        case .stepWeekdayPie:
            "Averages"
        case .weightLine(let average):
            "Weights"
        case .weightDiffBar:
            "Average Weight Change"
        }
    }
    
    var symbol: String {
        switch chartType {
        case .stepBar(_):
            "figure.walk"
        case .stepWeekdayPie:
            "calendar"
        case .weightLine(_), .weightDiffBar:
            "figure"
        }
    }
    
    var subTitle: String {
        switch chartType {
        case .stepBar(let average):
            "Avg: \(average.formatted())"
        case .stepWeekdayPie:
            "Last 28 Days"
        case .weightLine(let average):
            "Avg: \(average.formatted(.number.precision(.fractionLength(1))))"
        case .weightDiffBar:
            "Per Weekday (Last 28 Days)"
        }
    }
    
    var accessibilityLabel: String {
        switch chartType {
        case .stepBar(let average):
            "Bar chart, step count, last 28 days, average steps per day: \(average) steps"
        case .stepWeekdayPie:
            "Pie Chart, average steps per weekday"
        case .weightLine(let average):
            "Line Chart, weight, average weight: \(average.formatted(.number.precision(.fractionLength(1)))) pounds, goal weight: 155 pounds"
        case .weightDiffBar:
            "Bar Chart, average weight diffference per weekday"
        }
    }
}

#Preview {
    ChartContainer(chartType: .stepWeekdayPie) {
        Text("Chart goes here")
            .frame(minHeight: 150)
    }
}

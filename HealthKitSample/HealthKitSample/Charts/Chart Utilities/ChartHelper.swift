//
//  ChartHelpers.swift
//  HealthKitSample
//
//  Created by Justin on 7/11/24.
//

import Foundation
import Algorithms

struct ChartHelper {
    
    /// Converts ``HealthMetric`` array  to a ``DateValueChartData`` array
    /// - Parameter data: Array of ``HealthMetric``
    /// - Returns: Array of ``DateValueChartData``
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value) }
    }
    
    
    /// Parses data to find the first match for a selectedDate in our data
    /// - Parameters:
    ///   - data: Array of ``DateValueChartData``
    ///   - selectedDate: Date optional
    /// - Returns: Optional ``DateValueChartData``
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first { Calendar.current.isDate(selectedDate, inSameDayAs: $0.date )}
    }
    
    
    /// Getting the average number of steps per weekday
    /// - Parameter metric: Array of ``HealthMetric``
    /// - Returns: Array of ``DateValueChartData``
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [DateValueChartData] {
        let sortedByWeekday = metric.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayCharData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgSteps = total/Double(array.count)
            
            weekdayCharData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        return weekdayCharData
    }
    
    
    /// Getting the average for weight differences
    /// - Parameter weights: Array of ``HealthMetric``
    /// Health represents both weight and step data throughout the application but in this context it's the users weight data
    /// - Returns: Array of ``DateValueChartData``
    static func averageDailyWeightDiffs(for weights: [HealthMetric]) -> [DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        guard  weights.count > 1 else { return [] }
        
        for i in 1..<weights.count {
            let date = weights[i].date
            let diff = weights[i].value - weights[i - 1].value
            diffValues.append((date: date, value: diff))
        }

        let sortedByWeekday = diffValues.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }

        var weekdayChartData: [DateValueChartData] = []

        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total/Double(array.count)

            weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }

        return weekdayChartData
    }
}

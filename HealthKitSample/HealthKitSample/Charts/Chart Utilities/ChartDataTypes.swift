//
//  ChartDataTypes.swift
//  HealthKitSample
//
//  Created by Justin on 6/18/24.
//

import Foundation

struct DateValueChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}

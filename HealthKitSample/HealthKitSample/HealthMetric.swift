//
//  HealthMetric.swift
//  HealthKitSample
//
//  Created by Justin on 6/18/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

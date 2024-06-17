//
//  HealthKitManager.swift
//  HealthKitSample
//
//  Created by Justin on 6/17/24.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
}

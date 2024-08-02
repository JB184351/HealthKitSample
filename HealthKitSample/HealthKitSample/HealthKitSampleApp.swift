//
//  HealthKitSampleApp.swift
//  HealthKitSample
//
//  Created by Justin on 6/12/24.
//

import SwiftUI

@main
struct HealthKitSampleApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}

//
//  DateExtension.swift
//  HealthKitSample
//
//  Created by Justin on 6/18/24.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}

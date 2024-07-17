//
//  STError.swift
//  HealthKitSample
//
//  Created by Justin on 7/17/24.
//

import Foundation

enum STError: LocalizedError {
    case authNotDetermined
    case sharingDenied(quantity: String)
    case noData
    case unableToCompleteRequest
    case invalidValue
    
    var errorDescription: String? {
        switch self {
        case .authNotDetermined:
            "Need Access to Health Data"
        case .sharingDenied(_):
            "No Write Access"
        case .noData:
            "No Data"
        case .unableToCompleteRequest:
            "Unable to Complete Request"
        case .invalidValue:
            "Invalid Value"
        }
    }
    
    var failureReason: String {
        switch self {
        case .authNotDetermined:
            "You have not given access to your Health Data. Please go to Settings > Health > Data Access & Devices."
        case .sharingDenied(let quantity):
            "You have denied access to upload your \(quantity) data. \n\nYou can change this in Settings > Health > Data Access & Devices."
        case .noData:
            "There is no data for this Health statistic"
        case .unableToCompleteRequest:
            "We are unable to complete your request at this time. \n\nPlease try again later or contact support."
        case .invalidValue:
            "Must be a valid value with at least 1 decimal place"
        }
    }
}

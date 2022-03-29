//
//  DistanceConversionHelper.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/29.
//

import Foundation

class DistanceConversionHelper {

    static let share = DistanceConversionHelper()

    /// Function to calculate metric units
    /// Ceil() used to wrap Kilometers and rounded() from Miles result.
    /// - Parameters:
    ///   - value: The current unit value
    ///   - unit: The unit to be converted
    /// - Returns: Converted value.
    func convert(value: Double, from unit: DistanceUnit) -> Double {
        if unit == .miles {
            return (value * 1.60934).rounded()
        } else {
            return ceil(value * 0.621371)
        }
    }

}

//
//  Models.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/28.
//

import Foundation

enum DistanceUnit: String, Codable {
    case kilometers
    case miles
}

struct AirportModel: Codable, Comparable {

    // Required to make this model comparable, used in furthest airport algorithm
    static func < (lhs: AirportModel, rhs: AirportModel) -> Bool {
        lhs.furthestAirportDistance == rhs.furthestAirportDistance
    }

    // From API
    var id: String
    var latitude: Double
    var longitude: Double
    var name: String
    var city: String
    var countryId: String

    // Custom
    var nearestAirportId: String?
    var furthestAirportId: String?
    var furthestAirportDistance: Double?
    var highlight: Bool?

}

struct FlightModel: Codable {

    // From API
    var airlineId: String
    var flightNumber: Int
    var departureAirportId: String
    var arrivalAirportId: String

}

// Custom
struct FlightDetailModel: Codable {
    var airportId: String
    var flightNumber: Int
    var airlineId: String
    var distance: Double
}

struct SettingsModel: Codable {
    var unit: DistanceUnit
    init(unit: DistanceUnit = .kilometers) {
        self.unit = unit
    }
}

//
//  PersistenceModel.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/31.
//

import Foundation
import MapKit

class PersistenceStorage {

    private let userDefaults: UserDefaults
    private let settingsKey = "settings"
    private let airportKey = "airports"
    private let flightKey = "flights"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

}

// MARK: - Settings methods
extension PersistenceStorage {

    private func saveSettings(data: SettingsModel) {
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: settingsKey)
    }

    func updateSettingsUnit(value: DistanceUnit) {
        let data = SettingsModel(unit: value)
        saveSettings(data: data)
    }

    func loadSettings() -> SettingsModel {
        if let data = userDefaults.object(forKey: settingsKey) as? Data, let settings = try? PropertyListDecoder().decode(SettingsModel.self, from: data) {
            return settings
        } else {
            // Create and save default settings if there is none
            let defaultSettings = SettingsModel()
            saveSettings(data: defaultSettings)
            return defaultSettings
        }
    }

}

// MARK: - Airport methods
extension PersistenceStorage {

    typealias AirportData = [String: AirportModel]

    func saveAirports(data: [AirportModel]) {

        // Parse airports into a dictionary
        let dicAirports = Dictionary(data.map { ($0.id, $0) }) { first, _ in first }

        // Calculate distances
        let parser = Parser()
        let newData = parser.calculateAirportDistance(data: dicAirports)

        // Update local storage
        userDefaults.set(try? PropertyListEncoder().encode(newData), forKey: airportKey)

    }

    func updateAirports(data: AirportData) {
        // Update local storage
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: airportKey)
    }

    // Haven't used but in case there is a need to update a single airport
    // we might use something like this
    func updateAirport(data: AirportModel?) {
        guard let data = data else { return }
        var airports = loadAirports()
        if airports[data.id] != nil {
            airports[data.id] = data
            saveAirports(data: airports.map { $0.value })
        }
    }

    func loadAirports() -> AirportData {
        if let data = userDefaults.object(forKey: airportKey) as? Data, let airports = try? PropertyListDecoder().decode(AirportData.self, from: data) {
            return airports
        } else {
            return [:]
        }
    }

}

// MARK: - Flights methods
extension PersistenceStorage {

    func saveFlights(data: [FlightModel]) {
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: flightKey)
    }

    func loadFlights() -> [FlightModel] {
        if let data = userDefaults.object(forKey: flightKey) as? Data, let flights = try? PropertyListDecoder().decode([FlightModel].self, from: data) {
            return flights
        } else {
            return []
        }
    }

}

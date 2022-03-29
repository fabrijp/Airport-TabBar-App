//
//  DataHelper.swift
//  TabBar App
//
//  Created by Fabri on 2021/08/02.
//

import Foundation
import MapKit

class Parser {

    let storage = PersistenceStorage()

    // Algorithm to calculate distance between closest airports and the furthest two ones
    // Time complexity is O(n2) but consedering the size of N will not increase drastically,
    // any effort to increase its efficiency may won't be noticed.
    func calculateAirportDistance(data: [String: AirportModel]) -> [String: AirportModel] {

        var dataAirports = data

        // Loop airports
        for (airportId, airport) in dataAirports {

            // Temporary variables
            var nearestDistance: Double?
            var nearestAirportId: String?
            var furthestAirportId: String?
            var furthestDistance: Double?

            // Get location for current airport
            let location = CLLocation(latitude: airport.latitude, longitude: airport.longitude)

            // 2nd airport loop to calculate every distance
            for (nextId, nextAirport) in dataAirports {

                if airportId == nextId { continue }

                // Distance result is in meters, so we divide by 1000 to have in kilometers
                let targetLocation = CLLocation(latitude: nextAirport.latitude, longitude: nextAirport.longitude)
                var distance = location.distance(from: targetLocation)/1000
                if storage.loadSettings().unit == .miles {
                    distance = DistanceConversionHelper.share.convert(value: distance, from: .kilometers)
                }

                // All distances will be considered
                if let closestDistance = nearestDistance {
                    // But only the smallest ones will be updated
                    if distance < closestDistance {
                        nearestDistance = distance
                        nearestAirportId = nextAirport.id
                    }
                } else {
                    nearestDistance = distance
                    nearestAirportId = nextAirport.id
                }

                if let farDistance = furthestDistance {
                    if distance > farDistance {
                        furthestDistance = distance
                        furthestAirportId = nextAirport.id
                    }
                } else {
                    furthestDistance = distance
                    furthestAirportId = nextAirport.id
                }

                // Update airports dictionary
                dataAirports[airportId]?.nearestAirportId = nearestAirportId
                dataAirports[airportId]?.furthestAirportId = furthestAirportId
                dataAirports[airportId]?.furthestAirportDistance = furthestDistance

            }

        }

        // Set furtherstAirports
        if let furthestAirports = dataAirports.map({ $0.value }).sorted(by: { airportA, airportB in
            guard let distanceA = airportA.furthestAirportDistance, let distanceB = airportB.furthestAirportDistance else { return false }
            return distanceA < distanceB
        }).first, let nextId = furthestAirports.furthestAirportId {
            dataAirports[furthestAirports.id]?.highlight = true
            dataAirports[nextId]?.highlight = true
        }

        return dataAirports
    }

    func calculateFlightsDistance(fromAirportName selectedAirport: String) -> [FlightDetailModel] {

        let airports = storage.loadAirports()
        let flights = storage.loadFlights()
        var tmpFlights: [FlightDetailModel] = []

        let airport = airports.filter { $0.value.name.contains(selectedAirport) }
        guard let airportDeparture = airport.first?.value else { return [] }

        for flight in flights.filter({ $0.departureAirportId == airportDeparture.id }) {

            guard let airportArrival = airports[flight.arrivalAirportId] else { continue }
            // Location for departure airport
            let locationDeparture = CLLocation(latitude: airportDeparture.latitude, longitude: airportDeparture.longitude)
            let targetLocation = CLLocation(latitude: airportArrival.latitude, longitude: airportArrival.longitude)
            // Since distance is always calculated in meters, we have to divide it by 1000
            var distance = locationDeparture.distance(from: targetLocation)/1000
            if storage.loadSettings().unit == .miles {
                distance = DistanceConversionHelper.share.convert(value: distance, from: .kilometers)
            }
            // Construct and add data
            let theFlight = FlightDetailModel(airportId: airportArrival.id,
                                              flightNumber: flight.flightNumber,
                                              airlineId: flight.airlineId,
                                              distance: distance)
            tmpFlights.append(theFlight)
        }

        tmpFlights.sort(by: { $0.distance < $1.distance })

        return tmpFlights

    }

}

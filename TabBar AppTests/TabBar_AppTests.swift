//
//  TabBar_AppTests.swift
//  TabBar AppTests
//
//  Created by Fabri on 2021/07/21.
//

import XCTest
@testable import TabBar_App

class MockAPI: dataFetcher {

    func fetchAirports(_ completion: @escaping ([AirportModel]) -> Void) {
        // Read JSON file
        if let filePath = Bundle(for: type(of: self)).url(forResource: "airports_test", withExtension: "json")?.path {
            if let data = FileManager.default.contents(atPath: filePath) {
                do {
                    // Parse JSON to object
                    let decoder = JSONDecoder()
                    let result = try decoder.decode([AirportModel].self, from: data)
                    completion(result)
                } catch {
                    XCTFail("Could not decode json file")
                }
            } else {
                XCTFail("Could not read json file")
            }
        } else {
            XCTFail("Could not find json file")
        }
    }

    func fetchFlights(_ completion: @escaping ([FlightModel]) -> Void) {
        // Read JSON file
        if let filePath = Bundle(for: type(of: self)).url(forResource: "flights_test", withExtension: "json")?.path {
            if let data = FileManager.default.contents(atPath: filePath) {
                do {
                    // Parse JSON to object
                    let decoder = JSONDecoder()
                    let result = try decoder.decode([FlightModel].self, from: data)
                    completion(result)
                } catch {
                    XCTFail("Could not decode json file")
                }
            } else {
                XCTFail("Could not read json file")
            }
        } else {
            XCTFail("Could not find json file")
        }
    }

}

class TabBar_AppTests: XCTestCase {

    func testFetchAirportsFromAPI() throws {
        let api = MockAPI()
        let promise = expectation(description: "Airports data successfuly loaded")
        api.fetchAirports { airports in
            if airports.count == 0 {
                XCTFail("Could not retrieve airports data")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 3)
    }

    func testFetchFlightsFromAPI() throws {
        let api = MockAPI()
        let promise = expectation(description: "Flights data successfuly loaded")
        api.fetchFlights { flights in
            if flights.count == 0 {
                XCTFail("Could not retrieve flights data")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 3)
    }

    func testNearestAndFurthestAiports() throws {

        let api = MockAPI()
        api.fetchAirports { airports in
            // Parse airports into a dictionary
            let dicAirports = Dictionary(airports.map { ($0.id, $0) }) { first, _ in first }
            // Calculate distances
            let parser = Parser()
            let parsedAirports = parser.calculateAirportDistance(data: dicAirports)
            if parsedAirports.filter({$0.value.nearestAirportId == nil}).count > 0 {
                XCTFail("Could not calculcate distance between airports")
            }
            if parsedAirports.filter({$0.value.highlight == true}).count != 2 {
                XCTFail("Could not calculcate distance between furthest airports")
            }
        }

    }

    func testDistanceConversion() throws {
        let miles: Double = 1000
        let kilometers: Double = 1609
        if DistanceConversionHelper.share.convert(value: miles, from: .miles) != kilometers {
            XCTFail("Conversion from miles to kilometers failed")
        }
        if ceil(DistanceConversionHelper.share.convert(value: kilometers, from: .kilometers)) != miles {
            XCTFail("Conversion from kilometers to miles failed")
        }
    }

}

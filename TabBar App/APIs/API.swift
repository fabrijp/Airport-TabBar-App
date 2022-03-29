//
//  API.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/28.
//

import Foundation
import Combine

extension URL {
    static let airportsURL: String = "https://www.bitsbytes.jp/testflight/airports.json"
    static let flightsURL: String = "https://www.bitsbytes.jp/testflight/flights.json"
}

protocol dataFetcher {
    func fetchAirports(_ completion: @escaping ([AirportModel]) -> Void)
    func fetchFlights(_ completion: @escaping ([FlightModel]) -> Void)
}

class API {

    enum EndPoint {
        case airport
        case flights
    }

    var cancellables = Set<AnyCancellable>()
    private let storage = PersistenceStorage()

    // The error is out of scope for this project.
    // If any error occurs we will return an empty or nil object.
    private func fetchData<T: Decodable>(endPoint: EndPoint) -> AnyPublisher<[T], Never>? {

        var tmpURL: URL?

        switch endPoint {
        case .airport:
            tmpURL = URL(string: URL.airportsURL)
        case .flights:
            tmpURL = URL(string: URL.flightsURL)
        }

        guard let url = tmpURL else { return nil }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Array<T>.self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()

    }

}

extension API: dataFetcher {

    /// Fetch all airports data
    /// - Parameter completion: Return airport array
    func fetchAirports(_ completion:@escaping ([AirportModel]) -> Void) {
        print("looking for data")
        _ = fetchData(endPoint: .airport)?.sink { (items: [AirportModel]) in
            completion(items)
        }
        .store(in: &cancellables)

    }

    /// Fetch all flights data
    /// - Parameter completion: Return flight array
    func fetchFlights(_ completion:@escaping ([FlightModel]) -> Void) {

        _ = fetchData(endPoint: .flights)?.sink { (items: [FlightModel]) in
            completion(items)
        }
        .store(in: &cancellables)

    }

}

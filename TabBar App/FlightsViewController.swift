//
//  FlightsViewController.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/29.
//

import UIKit

class FlightsViewController: UIViewController {

    let api = API()
    let storage = PersistenceStorage()
    let parser = Parser()
    var flights: [FlightDetailModel] = []
    let selectedAirport = "Schiphol Airport"
    let tableView = UITableView()

    // Data
    let appData = PersistenceStorage()
    var metric: DistanceUnit = {
        PersistenceStorage().loadSettings().unit
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Flights"
        setupTableView()

    }

    override func viewWillAppear(_ animated: Bool) {

        // Check if metric unit has changed
        if metric != appData.loadSettings().unit {
            metric = appData.loadSettings().unit
            changeMetrics(newMetric: metric)
        }

        fetchFlights()

    }

    func fetchFlights() {
        api.fetchFlights { allFlights in
            // We may change this condition to be based on a returned error from the api
            if allFlights.count != self.flights.count {
                self.storage.saveFlights(data: allFlights)
                self.flights = self.parser.calculateFlightsDistance(fromAirportName: self.selectedAirport)
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }
            }
        }
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(FlightsViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    // Update current unit on all flights
    func changeMetrics(newMetric: DistanceUnit) {

        flights = flights.map({ flightsDetail in
            var tmpData = flightsDetail
            let unit: DistanceUnit = metric == .kilometers ? .miles:.kilometers
            tmpData.distance = DistanceConversionHelper.share.convert(value: tmpData.distance, from: unit)
            return tmpData
        })

        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }

    }

}

// TableView delegate
extension FlightsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FlightsViewCell else {
            return UITableViewCell()
        }

        if indexPath.row > flights.count - 1 { return cell }
        if let airport = appData.loadAirports()[flights[indexPath.row].airportId] {
            let distance = String(format: "%.2f", flights[indexPath.row].distance)
            let unit = metric == .kilometers ? "km":"miles"
            cell.nameLabel.text = airport.name
            let airline = flights[indexPath.row].airlineId
            let flight = flights[indexPath.row].flightNumber
            cell.detailLabel.text = "[\(airline)] #\(flight) - \(distance)\(unit)"
        }

        return cell
    }

}

// TableView delegate
extension FlightsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "From \(selectedAirport)"
    }

}

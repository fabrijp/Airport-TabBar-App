//
//  DetailView.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/28.
//

import UIKit
import MapKit

class AirportDetailView: UIViewController {

    var airport: AirportModel

    // Data
    let storage = PersistenceStorage()

    // Holds the label Y position on this view, starts with default value
    var yPosition = 75

    // Handling view controllers that have custom initializers
    // https://www.swiftbysundell.com/tips/handling-view-controllers-that-have-custom-initializers/
    init(airPort: AirportModel) {
        self.airport = airPort
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Setup view and text objects
        // UI/UX Design is out of scope for this project
        self.view.backgroundColor = .white
        self.title = "Airport Details"

        self.addTexts()

    }

    deinit {
        print("\(NSStringFromClass(AirportDetailView.self)) Deinitialized")
    }

}

extension AirportDetailView {

    // Fill the view
    func addTexts() {

        view.addSubview(addLabel(text: "ID", color: .black))
        view.addSubview(addLabel(text: airport.id, color: .gray))
        view.addSubview(addLabel(text: "Latitude", color: .black))
        view.addSubview(addLabel(text: "\(airport.latitude)", color: .gray))
        view.addSubview(addLabel(text: "Longitude", color: .black))
        view.addSubview(addLabel(text: "\(airport.longitude)", color: .gray))
        view.addSubview(addLabel(text: "Airport Name", color: .black))
        view.addSubview(addLabel(text: airport.name, color: .gray))
        view.addSubview(addLabel(text: "Country ID", color: .black))
        view.addSubview(addLabel(text: airport.countryId, color: .gray))

        if let closestAirport = storage.loadAirports().first(where: {$0.key == airport.nearestAirportId})?.value {
            // Get airport location
            let location = CLLocation(latitude: airport.latitude, longitude: airport.longitude)
            // Distance result is in meters, so we divide by 1000 to have in kilometers
            let targetLocation = CLLocation(latitude: closestAirport.latitude, longitude: closestAirport.longitude)
            var distanceWithin = location.distance(from: targetLocation)/1000
            if storage.loadSettings().unit != .kilometers {
                distanceWithin = DistanceConversionHelper.share.convert(value: distanceWithin, from: .kilometers)
            }
            // Add views
            view.addSubview(addLabel(text: "Nearest Airport", color: .black))
            let distance = String(format: "%.2f", distanceWithin)
            let unit = storage.loadSettings().unit == .kilometers ? "km":"miles"
            view.addSubview(addLabel(text: "\(closestAirport.name), \(distance)\(unit)", color: .gray))
        }

    }

    // Return a custom label
    func addLabel(text: String?, color: UIColor) -> UILabel {

        let labelText = UILabel()
        labelText.text = text
        labelText.textColor = color
        labelText.frame = CGRect(x: 10, y: yPosition, width: Int(self.view.frame.width - 10), height: 52)
        labelText.numberOfLines = 0

        // Increase Y for next label
        yPosition+=30

        return labelText
    }

}

//
//  AirportViewController.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/29.
//

import UIKit
import MapKit

class AirportViewController: UIViewController {

    let api = API()

    // Data
    var airportsCount = 0
    let storage = PersistenceStorage()
    var metric: DistanceUnit = {
        PersistenceStorage().loadSettings().unit
    }()

    // Map
    let mapView = MKMapView()
    var center: CLLocationCoordinate2D? // holds the center screen location

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Airports"
        loadMapAnnotations()

    }

    override func viewWillAppear(_ animated: Bool) {

        fetchAirports()

        // Check if metric unit has changed
        if metric != storage.loadSettings().unit {

            // Update local unit
            metric = storage.loadSettings().unit

            // Remove and add annotations again
            // We may have a way to update the locations, just haven't the time to look into it
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }

            loadMapAnnotations()

            // Update screen location
            if let center = center {
                DispatchQueue.main.async {
                    self.mapView.centerCoordinate = center
                }
            }
        }

    }

    func fetchAirports() {

        api.fetchAirports { allAirports in
            // We may change this condition to be based on a returned error from the api
            if allAirports.count != self.airportsCount {
                self.airportsCount = allAirports.count
                self.storage.saveAirports(data: allAirports)
                DispatchQueue.main.async {
                    self.loadMapAnnotations()
                }
            }
        }

    }

    func loadMapAnnotations() {

        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(AirportAnnotation.self))
        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = 0
        let mapWidth: CGFloat = view.frame.size.width
        let mapHeight: CGFloat = view.frame.size.height

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self

        for (_, airport) in storage.loadAirports() {

            let annotation = AirportAnnotation()
            annotation.airport = airport
            annotation.title = airport.name
            annotation.subtitle = "\(airport.city) (\(airport.countryId))"
            annotation.coordinate = CLLocationCoordinate2D(latitude: airport.latitude, longitude: airport.longitude)

            mapView.addAnnotation(annotation)

            // Select annotation if needed
//            mapView.selectAnnotation(annotation, animated: true)

        }

        view.addSubview(mapView)

    }

    // Custom annotation setup
    private func setupAirportAnnotationView(for annotation: AirportAnnotation, on mapView: MKMapView) -> MKAnnotationView {

        let reuseIdentifier = NSStringFromClass(AirportAnnotation.self)
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)

        flagAnnotationView.canShowCallout = true
        flagAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        // Icons made by https://www.flaticon.com/authors/pixel-perfect
        if let isHighlight = annotation.airport?.highlight {
            if isHighlight {
                flagAnnotationView.image = UIImage(named: "placeholder.png")
            }
        }

        return flagAnnotationView

    }

}

// MapKit delegates
extension AirportViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`,
            // as it's not an annotation view we wish to customize.
            return nil
        }

        var annotationView: MKAnnotationView?

        // Use our custom annotation
        if let annotation = annotation as? AirportAnnotation {
            annotationView = setupAirportAnnotationView(for: annotation, on: mapView)
        }

        return annotationView

    }

    // Callout when user taps the annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if let annotation = view.annotation as? AirportAnnotation, let airport = annotation.airport {
            let detalView = AirportDetailView(airPort: airport)
            detalView.view.frame = self.view.frame
            present(UINavigationController(rootViewController: detalView), animated: true)
        }

    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        center = mapView.centerCoordinate
    }

}

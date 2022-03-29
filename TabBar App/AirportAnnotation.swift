//
//  AirportAnnotation.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/29.
//

import MapKit

// Annotating a Map with Custom Data
// https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data
class AirportAnnotation: NSObject, MKAnnotation {

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate = CLLocationCoordinate2D(latitude: 37.779_379, longitude: -122.418_433)

    // Required if you set the annotation view's `canShowCallout` property to `true`
    var title: String?
    // This property defined by `MKAnnotation` is not required.
    var image: UIImage?
    var subtitle: String?
    // Airport data
    var airport: AirportModel?

}

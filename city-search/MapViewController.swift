//
//  MapViewController.swift
//  city-search
//
//  Created by James Langdon on 11/1/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var coordinates: Coordinate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let coordinates = coordinates else { return }
        let currentLocationCoordinates = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
        let coordinateRegion = MKCoordinateRegion(center: currentLocationCoordinates, latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(coordinateRegion, animated: false)
        
        mapView.setCenter(currentLocationCoordinates, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
        mapView.addAnnotation(annotation)
    }

}

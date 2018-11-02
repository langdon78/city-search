//
//  MapViewController.swift
//  city-search
//
//  Created by James Langdon on 11/1/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let mapRegionDistanceMeters: CLLocationDistance = 50000
    
    var city: City?
    var coordinates: CLLocationCoordinate2D? {
        guard let cityCoords = city?.coord else { return nil }
        return CLLocationCoordinate2DMake(cityCoords.lat, cityCoords.lon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = city?.name
        setRegion()
        dropPin()
    }
    
    private func setRegion() {
        guard let coordinates = coordinates else { return }
        let currentLocationCoordinates = coordinates
        let coordinateRegion = MKCoordinateRegion(center: currentLocationCoordinates, latitudinalMeters: mapRegionDistanceMeters, longitudinalMeters: mapRegionDistanceMeters)
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.setCenter(currentLocationCoordinates, animated: true)
    }
    
    private func dropPin() {
        guard let coordinates = coordinates else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }

}

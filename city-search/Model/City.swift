//
//  City.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

struct Coordinate: Codable {
    var lon: Double
    var lat: Double
}

struct City: Codable {
    var country: String
    var name: String
    var _id: Int
    var coord: Coordinate
    
    var fullName: String {
        return "\(name), \(country)"
    }
    
    var coordinates: String {
        return "Longitude: \(coord.lon)  Latitude: \(coord.lat)"
    }
}

//
//  CityTrie.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

class CityManager: WordTrie {
    
    private var duplicateNames: [String: [City]] = [:]
    private var newCities: [String: City] = [:]
    private var cityCount: Int = 0
    
    override public var count: Int {
        return cityCount
    }
    
    var allCities: [City] = []
    
    override init() {}
    
    convenience init?(data: Data?) {
        self.init()
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        var cities: [City] = []
        do {
            cities = try decoder.decode([City].self, from: data)
            insert(cities: cities)
        } catch {
            print(error)
        }
    }
    
    func insert(cities: [City]) {
        for city in cities {
//            print(round(Double(cityCount) / Double(cities.count) * 100))
            self.insert(city: city)
        }
        self.allCities = self.cities(for: words)
    }
    
    func insert(city: City) {
        let cityString = (city.name + ", " + city.country).lowercased()
        let result = insert(word: cityString)
        switch result {
        case .exists:
            if var dupCity = duplicateNames[cityString] {
                dupCity.append(city)
                duplicateNames.updateValue(dupCity, forKey: cityString)
            } else {
                duplicateNames[cityString] = [city]
            }
            cityCount += 1
        case .new:
            newCities[cityString] = city
            cityCount += 1
        case .empty:
            return
        }
    }
    
    func fetch(with prefix: String) -> [City] {
        let words = findWordsWithPrefix(prefix: prefix)
        return cities(for: words)
    }
    
    private func cities(for words: [String]) -> [City] {
        let new: [City] = words.compactMap { newCities[$0] }
        let existing: [City] = words.compactMap { duplicateNames[$0] }.flatMap { $0 }
        return (new + existing).sorted(by: { $0.name < $1.name })
    }
    
}

//
//  CityTrie.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

/// Delegate to inform loading progress
protocol ProgressDelegate {
    func fileLoaded()
    func loadingDataTrie(_ percent: Float)
}

// MARK: -
/// Interface for city data using prefix-
/// search optimized trie structure
final class CityRepository: WordTrie {
    
    var fetchTask: DispatchWorkItem?
    
    // Dictionary to allow fuzzy lookup
    // of city/country name
    private var cityLookup: [String: [City]] = [:]
    private var cityCount: Int = 0
    
    private var delegate: ProgressDelegate?
    
    override public var count: Int {
        return cityCount
    }
    
    // Store sorted list of cities
    // as optimization for empty prefix
    public var allCities: [City] = []
    
    private init(delegate: ProgressDelegate?) {
        self.delegate = delegate
    }
    
    public convenience init?(data: Data?, delegate: ProgressDelegate?) {
        self.init(delegate: delegate)
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        var cities: [City] = []
        do {
            cities = try decoder.decode([City].self, from: data)
            delegate?.fileLoaded()
            insert(cities: cities)
        } catch {
            print(error)
        }
    }
    
    private func insert(cities: [City]) {
        for city in cities {
            self.insertIntoTrie(city: city)
            self.allCities.append(city)
            delegate?.loadingDataTrie(Float(cityCount) / Float(cities.count))
        }
        allCities.sort(by: { $0.fullName < $1.fullName })
    }
    
    private func insertIntoTrie(city: City) {
        let cityString = city.fullName.lowercased()
        // Insert string into word trie
        insert(word: cityString)
        // Insert into City lookup dictionary
        if var dupCity = cityLookup[cityString] {
            dupCity.append(city)
            cityLookup.updateValue(dupCity, forKey: cityString)
        } else {
            cityLookup[cityString] = [city]
        }
        cityCount += 1
    }
    
    private func fetch(with prefix: String, fetchTask: DispatchWorkItem?, completion: @escaping ([City]?) -> Void) {
        if prefix.isEmpty {
            // return all pre-sorted cities
            completion(self.allCities)
        } else {
            // fetch all words matching given prefix
            findWordsWithPrefix(prefix: prefix) { words in
                guard let words = words, fetchTask === self.fetchTask, !(fetchTask?.isCancelled ?? true) else {
                    completion(nil)
                    return
                }
                // return matching city data
                self.cities(for: words) { cities in
                    guard fetchTask === self.fetchTask, !(fetchTask?.isCancelled ?? true) else {
                        completion(nil)
                        return
                    }
                    completion(cities)
                }
            }
        }
    }
    
    /// Perform a fetch task using DispatchWorkItem
    /// allowing for cancellation if called again
    /// prior to completion
    /// - Parameter prefix: prefix to filter city name
    public func executeFetchTask(with prefix: String, completion: @escaping ([City]?) -> Void) {
        fetchTask?.cancel()
        fetchTask = DispatchWorkItem { [weak self] in
            self?.fetch(with: prefix, fetchTask: self?.fetchTask, completion: completion)
        }
        DispatchQueue.global().async(execute: fetchTask!)
    }
    
    /// City names matching given prefix returned
    /// from trie are used to lookup associated
    /// cities. This returns multiple cities
    /// having the same city/country (i.e. Boston, US)
    private func cities(for words: [String], completion: ([City]?) -> Void) {
        let cities: [City] = words
            .compactMap { cityLookup[$0] }
            .flatMap { $0 }
            .sorted(by: { $0.fullName < $1.fullName })
        completion(cities)
    }
    
}

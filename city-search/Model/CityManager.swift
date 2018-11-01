//
//  CityTrie.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

class CityManager: WordTrie {
    var fetchTask: DispatchWorkItem?
    
    private var cityMap: [String: [City]] = [:]
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
        self.cities(for: words) { [weak self] cities in
            guard let cities = cities else { return }
            self?.allCities = cities
        }
    }
    
    func insert(city: City) {
        let cityString = city.fullName.lowercased()
        // Insert string into word trie
        insert(word: cityString)
        // Insert into City lookup dictionary
        if var dupCity = cityMap[cityString] {
            dupCity.append(city)
            cityMap.updateValue(dupCity, forKey: cityString)
        } else {
            cityMap[cityString] = [city]
        }
        cityCount += 1
    }
    
    private func fetch(with prefix: String, fetchTask: DispatchWorkItem?, completion: @escaping ([City]?) -> Void) {
        if prefix.isEmpty {
            completion(self.allCities)
        } else {
            findWordsWithPrefix(prefix: prefix) { words in
                guard let words = words, fetchTask === self.fetchTask, !(fetchTask?.isCancelled ?? true) else {
                    completion(nil)
                    return
                }
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
    
    public func executeFetchTask(with prefix: String, completion: @escaping ([City]?) -> Void) {
        fetchTask?.cancel()
        fetchTask = DispatchWorkItem { [weak self] in
            self?.fetch(with: prefix, fetchTask: self?.fetchTask, completion: completion)
        }
        DispatchQueue.global().async(execute: fetchTask!)
    }
    
    private func cities(for words: [String], completion: ([City]?) -> Void) {
        let cities: [City] = words
            .compactMap { cityMap[$0] }
            .flatMap { $0 }
            .sorted(by: { $0.fullName < $1.fullName })
        completion(cities)
    }
    
}

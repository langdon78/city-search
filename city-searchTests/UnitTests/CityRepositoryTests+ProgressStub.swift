//
//  city_searchTests.swift
//  city-searchTests
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import XCTest
@testable import city_search

class CityRepositoryTests: XCTestCase {
    
    var cityRepository: CityRepository!
    var fileLoadedCalled: Int = 0
    var loadingDataTrieCalled: Int = 0

    override func setUp() {
        cityRepository = CityRepository(data: mockCityData, delegate: self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitializationProgress() {
        XCTAssertEqual(fileLoadedCalled, 1)
        XCTAssertEqual(loadingDataTrieCalled, 20) // Number of records in mock
    }
    
    func testInitalizationMalformedData() {
        let cityRepositoryBad = CityRepository(data: mockCityDataMalformed, delegate: nil)
        XCTAssertEqual(cityRepositoryBad?.count, 0)
    }
    
    func testCityPrefixEmpty() {
        cityRepository.executeFetchTask(with: "") { cities in
            XCTAssertEqual(cities?.count, 20)
        }
    }
    
    func testCityPrefix() {
        cityRepository.executeFetchTask(with: "ma") { cities in
            XCTAssertEqual(cities?.map({$0.name}), ["Mahlsdorf","Markt Nordheim","Mariendorf"].sorted())
        }
    }
    
    func testCityPrefixNoMatch() {
        cityRepository.executeFetchTask(with: "mars") { cities in
            XCTAssertEqual(cities?.count, 0)
        }
    }

}

extension CityRepositoryTests: ProgressDelegate {
    func fileLoaded() {
        self.fileLoadedCalled += 1
    }
    
    func loadingDataTrie(_ percent: Float) {
        self.loadingDataTrieCalled += 1
    }
    
}

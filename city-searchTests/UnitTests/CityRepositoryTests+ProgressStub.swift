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

    override func setUp() {
        cityRepository = CityRepository(data: mockCityData, delegate: nil)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

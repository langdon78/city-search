//
//  WordTrieTests.swift
//  city-searchTests
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import XCTest
@testable import city_search

class WordTrieTests: XCTestCase {
    var wordTrie: WordTrie?

    override func setUp() {
        wordTrie = WordTrie()
        // load some mock data
        loadMockData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertDataCount() {
        XCTAssertEqual(wordTrie!.count, mockWords.count)
    }
    
    func testInsertDataValues() {
        let lowercasedMockWords = mockWords.map { $0.lowercased() }
        XCTAssertEqual(wordTrie!.words.sorted(), lowercasedMockWords.sorted())
    }
    
    func testInsertEmpty() {
        // given
        let emptyString = ""
        // when
        wordTrie!.insert(word: emptyString)
        // then
        testInsertDataCount()
        testInsertDataValues()
    }
    
    func testInsertExists() {
        // given
        let existsString = "Apple"
        // when
        wordTrie!.insert(word: existsString)
        // then
        testInsertDataCount()
        testInsertDataValues()
    }
    
    func testFetchPrefix() {
        // given
        let prefixString = "a"
        // when
        wordTrie?.findWordsWithPrefix(prefix: prefixString) { fetchResult in
            // then
            XCTAssertTrue(fetchResult == ["apple"])
        }
    }
    
    func testFetchPrefixCaseSensitive() {
        // given
        let prefixString = "A"
        // when
        wordTrie?.findWordsWithPrefix(prefix: prefixString) { fetchResult in
            // then
            XCTAssertTrue(fetchResult == ["apple"])
        }

    }
    
    func testFetchPrefixMultipleCharacters() {
        // given
        let prefixString = "App"
        // when
        wordTrie?.findWordsWithPrefix(prefix: prefixString) { fetchResult in
            // then
            XCTAssertTrue(fetchResult == ["apple"])
        }
    }
    
    func testFetchPrefixMultipleMatches() {
        // given
        let prefixString = "C"
        // when
        wordTrie?.findWordsWithPrefix(prefix: prefixString) { fetchResult in
            // then
            XCTAssertTrue(fetchResult?.sorted() == ["carrot","cucumber"])
        }

    }

    private func loadMockData() {
        for word in mockWords {
            let _ = wordTrie?.insert(word: word)
        }
    }
}

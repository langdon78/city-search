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
        XCTAssertEqual(wordTrie!.words.sorted(), mockWords.sorted())
    }
    
    func testInsertEmpty() {
        // given
        let emptyString = ""
        // when
        let insertResult = wordTrie!.insert(word: emptyString)
        // then
        XCTAssertTrue(insertResult == .empty)
        testInsertDataCount()
        testInsertDataValues()
    }
    
    func testInsertExists() {
        // given
        let existsString = "Apple"
        // when
        let insertResult = wordTrie!.insert(word: existsString)
        // then
        XCTAssertTrue(insertResult == .exists)
        testInsertDataCount()
        testInsertDataValues()
    }
    
    func testFetchPrefix() {
        // given
        let prefixString = "A"
        // when
        let fetchResult = wordTrie?.findWordsWithPrefix(prefix: prefixString)
        // then
        XCTAssertTrue(fetchResult == ["Apple"])
    }
    
    func testFetchPrefixCaseSensitive() {
        // given
        let prefixString = "a"
        // when
        let fetchResult = wordTrie?.findWordsWithPrefix(prefix: prefixString)
        // then
        XCTAssertTrue(fetchResult != ["Apple"])
    }
    
    func testFetchPrefixMultipleCharacters() {
        // given
        let prefixString = "App"
        // when
        let fetchResult = wordTrie?.findWordsWithPrefix(prefix: prefixString)
        // then
        XCTAssertTrue(fetchResult == ["Apple"])
    }
    
    func testFetchPrefixMultipleMatches() {
        // given
        let prefixString = "C"
        // when
        let fetchResult = wordTrie?.findWordsWithPrefix(prefix: prefixString)
        // then
        XCTAssertTrue(fetchResult?.sorted() == ["Carrot","Cucumber"])
    }

    private func loadMockData() {
        for word in mockWords {
            let _ = wordTrie?.insert(word: word)
        }
    }
}

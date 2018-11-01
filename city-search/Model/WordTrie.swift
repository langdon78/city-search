//
//  Trie.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

class WordTrie {
    
    enum InsertResult {
        case empty
        case new
        case exists
    }
    
    public var count: Int {
        return wordCount
    }
    
    public var isEmpty: Bool {
        return wordCount == 0
    }
    
    public var words: [String] {
        return wordsInSubtrie(rootNode: root, partialWord: "")
    }
    fileprivate let root: CharacterNode
    fileprivate var wordCount: Int
    
    init() {
        root = CharacterNode()
        wordCount = 0
    }

    /// Attempts to insert word into Trie.
    ///
    /// - Parameter word: the word to be inserted.
    /// - Returns: outcome of attempted insert
    public func insert(word: String) -> InsertResult {
        guard !word.isEmpty else {
            return .empty
        }
        
        // Visit node for existing characters or create new node
        var currentNode = root
        for character in word.lowercased() {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }

        guard !currentNode.isEnd else {
            return .exists
        }
        
        wordCount += 1
        currentNode.isEnd = true
        return .new
    }
    
    /// Returns an array of words in a subtrie of the trie that start
    /// with given prefix
    ///
    /// - Parameters:
    ///   - prefix: the letters for word prefix
    /// - Returns: the words in the subtrie that start with prefix
    public func findWordsWithPrefix(prefix: String) -> [String] {
        var words = [String]()
        let prefixLowerCased = prefix.lowercased()
        if let lastNode = findLastNodeOf(word: prefixLowerCased) {
            if lastNode.isEnd {
                words.append(prefixLowerCased)
            }
            for childNode in lastNode.children.values {
                let childWords = wordsInSubtrie(rootNode: childNode, partialWord: prefixLowerCased)
                words += childWords
            }
        }
        return words
    }
    
    /// Attempts to walk to the last node of a word.  The
    /// search will fail if the word is not present. Doesn't
    /// check if the node is terminating
    private func findLastNodeOf(word: String) -> CharacterNode? {
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return nil
            }
            currentNode = childNode
        }
        return currentNode
    }
    
    /// Returns an array of words in a subtrie of the trie
    private func wordsInSubtrie(rootNode: CharacterNode, partialWord: String) -> [String] {
        var subtrieWords = [String]()
        var previousLetters = partialWord
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        if rootNode.isEnd {
            subtrieWords.append(previousLetters)
        }
        for childNode in rootNode.children.values {
            let childWords = wordsInSubtrie(rootNode: childNode, partialWord: previousLetters)
            subtrieWords += childWords
        }
        return subtrieWords
    }
    
}

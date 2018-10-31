//
//  Node.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

final class CharacterNode {
    
    var value: Character?
    weak var parent: CharacterNode?
    var children: [Character: CharacterNode] = [:]
    var isEnd = false
    var isLeaf: Bool {
        return children.count == 0
    }
    
    init(value: Character? = nil, parent: CharacterNode? = nil) {
        self.value = value
        self.parent = parent
    }
    
    func add(value: Character) {
        guard children[value] == nil else {
            return
        }
        children[value] = CharacterNode(value: value, parent: self)
    }
    
}

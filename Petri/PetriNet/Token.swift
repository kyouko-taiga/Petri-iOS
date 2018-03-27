//
//  Token.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

/**
    A token value type.

    A token can be either a constant representing an instance of *something*,
    or a variable representing any constant.

    - SeeAlso: `Place`
 */
enum Token: Hashable, CustomStringConvertible {

    case constant(value: Character)
    case variable(name: Character)

    var hashValue: Int {
        switch self {
        case .constant(value: let v):
            return v.hashValue
        case .variable(name: let n):
            return 1 ^ n.hashValue
        }
    }

    var displayText: String {
        switch self {
        case .constant(value: let v):
            return String(v)
        case .variable(name: let n):
            return String(n)
        }
    }

    var description: String {
        switch self {
        case .constant(value: let v):
            return String(v)
        case .variable(name: let n):
            return "$" + String(n)
        }
    }

}



func == (left: Token, right: Token) -> Bool {
    switch (left, right) {
    case (.constant(value: let l), .constant(value: let r)):
        return l == r
    case (.variable(name: let l), .variable(name: let r)):
        return l == r
    default:
        return false
    }
}


/// A multiset of `Token`.
typealias Marking = Multiset<Token>

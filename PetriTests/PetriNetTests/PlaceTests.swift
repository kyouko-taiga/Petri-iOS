//
//  PlaceTests.swift
//  Petri
//
//  Created by Dimitri Racordon on 03.02.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import XCTest
@testable import Petri


fileprivate let o = Token.constant(value: "o")
fileprivate let x = Token.constant(value: "x")


class PlaceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        // Test Place designated initializer.
        var place = Place(
            marking: [o, o, x],
            sprite: PlaceSprite(size: CGSize(width: 256, height: 256)),
            tokenSpriteSize: CGSize(width: 32, height: 32))

        XCTAssertEqual(place.marking, Marking([o, o, x]))
        XCTAssertEqual(place.node.size, CGSize(width: 256, height: 256))
        XCTAssertEqual(place.tokenSpriteSize, CGSize(width: 32, height: 32))

        // Test Place convenience initializers.
        place = Place(
            marking: [o, o, x],
            spriteSize: CGSize(width: 256, height: 256),
            tokenSpriteSize: CGSize(width: 32, height: 32))

        XCTAssertEqual(place.marking, Marking([o, o, x]))
        XCTAssertEqual(place.node.size, CGSize(width: 256, height: 256))
        XCTAssertEqual(place.tokenSpriteSize, CGSize(width: 32, height: 32))
    }

    func testAdd() {
        let place = Place(marking: [o, o, x], spriteSize: CGSize(width: 256, height: 256))

        place.add(o)
        XCTAssertEqual(place.marking, Marking([o, o, o, x]))

        place.add(x)
        XCTAssertEqual(place.marking, Marking([o, o, o, x, x]))
    }

    func testRemove() {
        let place = Place(marking: [o, o, x], spriteSize: CGSize(width: 256, height: 256))

        place.remove(o)
        XCTAssertEqual(place.marking, Marking([o, x]))

        place.remove(x)
        XCTAssertEqual(place.marking, Marking([o]))
    }

    func testAddOperator() {
        let place = Place(marking: [o, o, x], spriteSize: CGSize(width: 256, height: 256))

        place << [o, x]
        XCTAssertEqual(place.marking, Marking([o, o, o, x, x]))
    }

    func testRemoveOperator() {
        let place = Place(marking: [o, o, x], spriteSize: CGSize(width: 256, height: 256))

        place >> [o, x]
        XCTAssertEqual(place.marking, Marking([o]))
    }

}

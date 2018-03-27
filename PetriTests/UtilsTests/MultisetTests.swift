//
//  MultisetTests.swift
//  Petri
//
//  Created by Dimitri Racordon on 29.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import XCTest
@testable import Petri


class MultisetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        let multiset = Multiset<Int>()

        XCTAssertTrue(multiset.isEmpty)
        XCTAssertEqual(multiset.count, 0)
        XCTAssertEqual(multiset.distinctCount, 0)
    }

    func testInitFromArray() {
        let multiset: Multiset = [0, 0, 1]

        XCTAssertEqual(multiset.count, 3)
        XCTAssertEqual(multiset.distinctCount, 2)
        XCTAssertEqual(multiset.occurrences(of: 0), 2)
        XCTAssertEqual(multiset.occurrences(of: 1), 1)
    }

    func testInitFromDictionary() {
        let multiset: Multiset = [0: 2, 1: 1]

        XCTAssertEqual(multiset.count, 3)
        XCTAssertEqual(multiset.distinctCount, 2)
        XCTAssertEqual(multiset.occurrences(of: 0), 2)
        XCTAssertEqual(multiset.occurrences(of: 1), 1)
    }

    func testInsert() {
        var multiset = Multiset<Int>()

        multiset.insert(0)
        XCTAssertEqual(multiset.occurrences(of: 0), 1)
        multiset.insert(0, occurrences: 2)
        XCTAssertEqual(multiset.occurrences(of: 0), 3)

        multiset.insert(1, occurrences: 2)
        XCTAssertEqual(multiset.occurrences(of: 0), 3)
        XCTAssertEqual(multiset.occurrences(of: 1), 2)
    }

    func testRemove() {
        var multiset: Multiset = [0: 3, 1: 2]

        multiset.remove(0)
        XCTAssertEqual(multiset.occurrences(of: 0), 2)
        multiset.remove(0, occurrences: 2)
        XCTAssertEqual(multiset.occurrences(of: 0), 0)

        multiset.remove(1, occurrences: 2)
        XCTAssertEqual(multiset.occurrences(of: 1), 0)
    }

    func testEquality() {
        XCTAssertEqual(Multiset<Int>(),        Multiset<Int>())
        XCTAssertEqual(Multiset([0, 0]),       Multiset([0, 0]))
        XCTAssertEqual(Multiset([0, 0, 1]),    Multiset([0, 0, 1]))

        XCTAssertNotEqual(Multiset<Int>(),     Multiset([0, 0]))
        XCTAssertNotEqual(Multiset([0, 0]),    Multiset<Int>())
        XCTAssertNotEqual(Multiset([0, 0, 1]), Multiset<Int>([0, 1]))
    }

    func testIsSubset() {
        XCTAssertTrue(Multiset<Int>()      <= Multiset<Int>())
        XCTAssertTrue(Multiset<Int>()      <= Multiset([0, 0]))

        XCTAssertTrue(Multiset([0, 0])     <= Multiset([0, 0]))
        XCTAssertTrue(Multiset([0, 0])     <= Multiset([0, 0, 1]))
        XCTAssertTrue(Multiset([0, 1])     <= Multiset([0, 0, 1]))

        XCTAssertFalse(Multiset([0, 0])    <= Multiset<Int>())
        XCTAssertFalse(Multiset([0, 0])    <= Multiset([0, 1]))
        XCTAssertFalse(Multiset([0, 0, 1]) <= Multiset([0, 1]))
    }

    func testIsSuperset() {
        XCTAssertTrue(Multiset<Int>()      >= Multiset<Int>())
        XCTAssertTrue(Multiset([0, 0])     >= Multiset<Int>())

        XCTAssertTrue(Multiset([0, 0])     >= Multiset([0, 0]))
        XCTAssertTrue(Multiset([0, 0, 1])  >= Multiset([0, 0]))
        XCTAssertTrue(Multiset([0, 0, 1])  >= Multiset([0, 1]))

        XCTAssertFalse(Multiset<Int>()     >= Multiset([0, 0]))
        XCTAssertFalse(Multiset([0, 1])    >= Multiset([0, 0]))
        XCTAssertFalse(Multiset([0, 1])    >= Multiset([0, 0, 1]))
    }

    func testUnion() {
        XCTAssertEqual(Multiset<Int>()     | Multiset<Int>(),     Multiset<Int>())

        XCTAssertEqual(Multiset([0, 0])    | Multiset<Int>(),     Multiset([0, 0]))
        XCTAssertEqual(Multiset<Int>()     | Multiset([0, 0]),    Multiset([0, 0]))
        XCTAssertEqual(Multiset([0, 0])    | Multiset([0, 0]),    Multiset([0, 0, 0, 0]))

        XCTAssertEqual(Multiset([0, 0, 0]) | Multiset([0, 0, 1]), Multiset([0, 0, 0, 0, 0, 1]))
        XCTAssertEqual(Multiset([0, 0, 1]) | Multiset([0, 0, 0]), Multiset([0, 0, 0, 0, 0, 1]))
    }

    func testIntersection() {
        XCTAssertEqual(Multiset<Int>()     & Multiset<Int>(),     Multiset<Int>())

        XCTAssertEqual(Multiset([0, 0])    & Multiset<Int>(),     Multiset<Int>())
        XCTAssertEqual(Multiset<Int>()     & Multiset([0, 0]),    Multiset<Int>())
        XCTAssertEqual(Multiset([0, 0])    & Multiset([0, 0]),    Multiset([0, 0]))

        XCTAssertEqual(Multiset([0, 0, 0]) & Multiset([0, 0, 1]), Multiset([0, 0]))
        XCTAssertEqual(Multiset([0, 0, 1]) & Multiset([0, 0, 0]), Multiset([0, 0]))
    }

    func testDifference() {
        XCTAssertEqual(Multiset<Int>()     - Multiset<Int>(),     Multiset<Int>())

        XCTAssertEqual(Multiset([0, 0])    - Multiset<Int>(),     Multiset([0, 0]))
        XCTAssertEqual(Multiset<Int>()     - Multiset([0, 0]),    Multiset<Int>())
        XCTAssertEqual(Multiset([0, 0])    - Multiset([0, 0]),    Multiset<Int>())

        XCTAssertEqual(Multiset([0, 0, 0]) - Multiset([0, 0, 1]), Multiset([0]))
        XCTAssertEqual(Multiset([0, 0, 1]) - Multiset([0, 0, 0]), Multiset([1]))
    }

    func testSymmetricDifference() {
        XCTAssertEqual(Multiset<Int>()     ^ Multiset<Int>(),     Multiset<Int>())

        XCTAssertEqual(Multiset([0, 0])    ^ Multiset<Int>(),     Multiset([0, 0]))
        XCTAssertEqual(Multiset<Int>()     ^ Multiset([0, 0]),    Multiset([0, 0]))
        XCTAssertEqual(Multiset([0, 0])    ^ Multiset([0, 0]),    Multiset<Int>())

        XCTAssertEqual(Multiset([0, 0, 0]) ^ Multiset([0, 0, 1]), Multiset([0, 1]))
        XCTAssertEqual(Multiset([0, 0, 1]) ^ Multiset([0, 0, 0]), Multiset([0, 1]))
    }

}

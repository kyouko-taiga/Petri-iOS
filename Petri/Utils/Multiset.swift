//
//  Multiset.swift
//  Petri
//
//  Created by Dimitri Racordon on 28.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

/**
    An unordered collection of elements.

    # Overview

    You can use a set instead of a set or a array when you need to store
    multiple instances of the same element, but still need to use the usual
    set operations, such as the union or the intersection.

    You can create a multiset with any element that conforms to the `Hashable`
    protocol.

    Multisets can be initialized from an array, or a dictionary whose keys
    are the elements to be inserted in the multiset and values their number of
    occurrences.

    ```
    let fruitBag: Multiset = ["orange", "orange", "banana"]
    if fruitBag.contains("orange") {
        print("There are some oranges.")
    }
    // Prints "The are some oranges"
    ```

    You ask for the number of occurrences with the method `occurrences(of:)`:

    ```
    print(fruitBag.occurrences(of: "orange"))
    // Prints "2"
    ```

    # Multiset Operations

    Multisets provide the usual operations associated with sets, in the form
    of operators:

    * Use the `<=(_:_:)` operator to test whether every element in the left
      multiset are also in the right one:
    * Use the `|(_:_:)` operator to compute the union of two multisets, i.e.
      all the elements from both multisets.
    * Use the `&(_:_:)` operator to compute the intersection of two multisets,
      i.e. the elements that are in both multisets.
    * Use the `-(_:_:)` operator to compute the difference between two
      multisets, i.e. the elements of the left multiset that are not in the
      right one.
    * Use the `^(_:_:)` operator to compute the symmetric difference between
      two multisets, i.e. the elements that are are in either one multiset or
      the other, but not in both.

    They also conform to the `Sequence` protocol. As such, they come equipped
    with a suite of methods to access their elements.

    ```
    for fruit in fruitBag {
        print(fruit)
    }
    // Prints "banana"
    // Prints "orange"
    // Prints "orange"
    ```
 */
struct Multiset<T: Hashable> {

    fileprivate var content = [T: Int]()

    init() {}

    init<S: Sequence>(_ elements: S) where S.Iterator.Element == T {
        for element in elements {
            self.content[element] = (self.content[element] ?? 0) + 1
        }
    }

    init<S: Sequence>(_ elements: S) where S.Iterator.Element == (key: T, value: Int) {
        for (element, occurrences) in elements {
            self.content[element] = occurrences
        }
    }

    // MARK: Querying the multiset

    var isEmpty: Bool {
        return self.content.isEmpty
    }

    var count: Int {
        return (self.content.map { $1 }).reduce(0, +)
    }

    func occurrences(of element: T) -> Int {
        return self.content[element] ?? 0
    }

    var distinctCount: Int {
        return self.content.count
    }

    var distinctElements: LazyMapCollection<Dictionary<T, Int>, T> {
        return self.content.keys
    }

    // MARK: Inserting and removing elements

    mutating func insert(_ element: T, occurrences: Int = 1) {
        precondition(occurrences > 0)
        self.content[element] = (self.content[element] ?? 0) + occurrences
    }

    mutating func remove(_ element: T, occurrences: Int = 1) {
        precondition(occurrences > 0)
        precondition(self.content[element] != nil)
        precondition(self.content[element]! >= occurrences)

        let newCount = self.content[element]! - occurrences
        if newCount > 0 {
            self.content[element] = newCount
        } else {
            self.content.removeValue(forKey: element)
        }
    }

}


// MARK: Manipulating the multiset

/// Returns whether the left multiset is a subset of (or is equal to) the right one.
func <= <T> (left: Multiset<T>, right: Multiset<T>) -> Bool {
    for (element, occurrences) in left.content {
        if right.occurrences(of: element) < occurrences {
            return false
        }
    }
    return true
}

/// Returns whether the right multiset is a subset of (or is equal to) the left one.
func >= <T> (left: Multiset<T>, right: Multiset<T>) -> Bool {
    return right <= left
}

/// Returns the union of two multisets.
func | <T> (left: Multiset<T>, right: Multiset<T>) -> Multiset<T> {
    var rv = left
    for (element, occurrences) in right.content {
        rv.insert(element, occurrences: occurrences)
    }

    return rv
}

/// Returns the intersection of two multisets.
func & <T> (left: Multiset<T>, right: Multiset<T>) -> Multiset<T> {
    var rv = Multiset<T>()
    for (element, occurrences) in left.content {
        if right.occurrences(of: element) > 0 {
            rv.insert(element, occurrences: min(occurrences, right.occurrences(of: element)))
        }
    }

    return rv
}

/// Returns the difference of two multisets.
func - <T> (left: Multiset<T>, right: Multiset<T>) -> Multiset<T> {
    var rv = left
    for (element, occurrences) in right.content {
        if let n = rv.content[element] {
            rv.remove(element, occurrences: min(n, occurrences))
        }
    }

    return rv
}

/// Returns the symmtetric difference of two multisets.
func ^ <T> (left: Multiset<T>, right: Multiset<T>) -> Multiset<T> {
    var rv = Multiset<T>()
    for element in Set<T>([T](left.distinctElements) + [T](right.distinctElements)) {
        let n = abs(left.occurrences(of: element) - right.occurrences(of: element))
        if n > 0 {
            rv.insert(element, occurrences: n)
        }
    }

    return rv
}


extension Multiset: ExpressibleByArrayLiteral {

    init(arrayLiteral elements: T...) {
        self.init(elements)
    }

}


extension Multiset: ExpressibleByDictionaryLiteral {

    init(dictionaryLiteral elements: (T, Int)...) {
        self.init(elements.map { (key: $0.0, value: $0.1) })
    }

}


extension Multiset: Hashable {

    var hashValue: Int {
        var rv = 3
        rv = (31 ^ rv) ^ self.count
        rv = (31 ^ rv) ^ self.distinctCount
        for element in self {
            rv = (31 ^ rv) ^ element.hashValue
        }

        return rv
    }

    static func == <T> (left: Multiset<T>, right: Multiset<T>) -> Bool {
        if left.count != right.count || left.distinctCount != right.distinctCount {
            return false
        }

        for element in left {
            if left.occurrences(of: element) != right.occurrences(of: element) {
                return false
            }
        }

        return true
    }

}


extension Multiset: Sequence {

    func makeIterator() -> AnyIterator<T> {
        var iterator = self.content.makeIterator()
        var occurrences = 0
        var element: T? = nil

        return AnyIterator {
            if occurrences > 0 {
                occurrences -= 1
                return element
            }

            let it = iterator.next()
            element = it?.key
            occurrences = it?.value ?? 1
            occurrences -= 1

            return element
        }
    }

}


extension Multiset: CustomStringConvertible {

    var description: String {
        return String(describing: self.content)
    }

}

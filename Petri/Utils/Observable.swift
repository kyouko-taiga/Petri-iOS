//
//  Observable.swift
//  Petri
//
//  Created by Dimitri Racordon on 02.02.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

struct Observable<T> {

    var value: T {
        didSet {
            for obs in self.observers {
                obs.callback(value)
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    private var observers = [Observer<T>]()

    mutating func observe(using block: @escaping (T) -> ()) -> Observer<T> {
        let obs = Observer(block)
        self.observers.append(obs)
        return obs
    }

    mutating func unobserve(observer: Observer<T>) {
        if let index = self.observers.index(where: { $0 === observer }) {
            self.observers.remove(at: index)
        }
    }

}


class Observer<T> {

    let callback: (T) -> ()

    init(_ callback: @escaping (T) -> ()) {
        self.callback = callback
    }

}


postfix operator ~
postfix func ~ <T> (observable: Observable<T>) -> T {
    return observable.value
}


infix operator ~=
func ~= <T> (observable: inout Observable<T>, value: T) {
    observable.value = value
}

//
//  GameEvent.swift
//  Petri
//
//  Created by Dimitri Racordon on 02.02.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//


/// The possible game events.
enum Event {

    // MARK: Transition events

    case transitionFired(transition: Transition)
}


protocol EventDispatcher {

    mutating func addEventObserver(using block: @escaping (Event) -> ()) -> EventObserver

    mutating func removeEventObserver(_ observer: EventObserver)

    func dispatchEvent(_ event: Event)

}


class EventObserver {

    let notify: (Event) -> ()

    init(_ callback: @escaping (Event) -> ()) {
        self.notify = callback
    }

}

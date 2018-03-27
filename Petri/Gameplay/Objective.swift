//
//  Objective.swift
//  Petri
//
//  Created by Dimitri Racordon on 28.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


/**
    The common requirements for puzzle objectives.

    Puzzle objectives represent the goal (or goals) that the user should reach
    in each puzzle. They can take any form such, as reaching a given marking
    (see `MarkingObjective`) or enabling a given transition.

    # Protocol Conformance

    The `state` property should indicate the current state of the objective,
    It can take the value `met`, `unmet` or `failed`. Note that `unmet`
    differs from `failed` in the sense that a `failed` can no longer be `met`
    in the future, while an `unmet` could eventually be.

    The optional `observer` property should allow the user to provide an
    observer that should be called whenever the state of the objective
    changes. Note that the observer is should *not* be called at
    initialization.

    The method `update()` should implement the logic to update the state of an
    objective. It will be called every time a change occurs in the model.

    The method `clean()` should clean every data that has been setup through
    the lifetime of the objective (e.g. visual representations).
 */
protocol Objective {

    var state: ObjectiveState { get }
    var observer: (ObjectiveState) -> Void { get set }

    mutating func update()
    mutating func clean()

}


/// The possible values for the state of puzzle objectives.
enum ObjectiveState {
    case met, unmet, failed
}

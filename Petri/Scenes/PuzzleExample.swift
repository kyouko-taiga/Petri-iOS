//
//  PuzzleExample.swift
//  Petri
//
//  Created by Dimitri Racordon on 27.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


class PuzzleExample: PuzzleScene {

    override func createModel() {

        // Thanks to Swift allowing emoji to be used as variable names, we can
        // define some cool tokens ;)

        let 🐶 = Token.constant(value: "🐶")
        let 🐔 = Token.constant(value: "🐔")
        let 🐱 = Token.constant(value: "🐱")

        // Places can be created with the makePlace helper method.
        // Coordinates should be given in absolute values and the model shoul
        // be centered around coordninates <0,0>.

        let p = makePlace(marking: [🐶, 🐶, 🐔], at: CGPoint(x: -128, y: +128))
        let q = makePlace(marking: [🐱, 🐱], at: CGPoint(x: +384, y: +128))

        // Transition can be created with the makeTransition helper method.
        // Preconditions and postconditions can be defined with the `arc`
        // helper method, which also allows to indicate the arc styling.

        makeTransition(
            conditions: [
                arc(from: p, consuming: [🐶], curvedBy: -30),
                arc(from: q, consuming: [🐱]),
                arc(to: p, producing: [🐔, 🐱], curvedBy: -30)
            ],
            at: CGPoint(x: +128, y: +128))

        makeTransition(
            conditions: [
                arc(from: p, consuming: [🐔], curvedBy: -30),
                arc(to: p, producing: [🐶], curvedBy: -30)
            ],
            at: CGPoint(x: -384, y: +128))

        makeTransition(
            conditions: [
                arc(from: p, consuming: [🐶, 🐔], curvedBy: 40),
                arc(to: q, producing: [🐱], curvedBy: 40)
            ],
            at: CGPoint(x: +128, y: -128))

        // Puzzle objectives allow to define the goals of a particular puzzle.
        // They hold an `observer` closure which acts as a callback whenever
        // the state of the objective changes.

        let objective = MarkingObjective(on: p, marking: [🐶, 🐱, 🐱, 🐱]) {
            switch $0 {
            case .met:
                print("The marking objective is met.")
            case .unmet:
                print("The marking objective is not met.")
            default:
                break
            }
        }

        // Objectives can be added with the addbjective helper method.

        addObjective(objective)

        // Camera panning and zooming is enabled by default, but can be
        // controlled with `isPanningEnabled` and `isZoomingEnabled`.

        self.isPanningEnabled = true
        self.isZoomingEnabled = true

        addEventObserver { event in
            switch event {
            case .transitionFired(transition: let t):
                print("Transition \(t) was fired.")
            }
        }

    }

}

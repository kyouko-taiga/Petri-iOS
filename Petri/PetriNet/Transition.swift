//
//  Transition.swift
//  Petri
//
//  Created by Dimitri Racordon on 25.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import GameplayKit


/**
    A transition of a Petri Net model.

    The `Transition` class represents a place at the abstract level. It is
    mapped to a visual representation that can be attached to a scene.
 */
class Transition: GKEntity {

    init(sprite: TransitionSprite) {
        super.init()
        self.addComponent(GKSKNodeComponent(node: sprite))
    }

    convenience init(spriteSize: CGSize? = nil) {
        var sprite: TransitionSprite?

        if let s = spriteSize {
            sprite = TransitionSprite(size: s)
        } else {
            sprite = TransitionSprite()
        }

        self.init(sprite: sprite!)
    }

    var node: TransitionSprite {
        return self.component(ofType: GKSKNodeComponent.self)!.node as! TransitionSprite
    }

    // MARK: Definition of pre/post conditions

    var preconditions = [Arc]()
    var postconditions = [Arc]()

    func pre(
        from place: Place, consuming tokens: Marking, curvedBy curvature: CGFloat = 0) -> Arc
    {
        let arc = Arc(from: place, to: self, labeled: tokens, curvedBy: curvature)
        self.preconditions.append(arc)
        return arc
    }

    func post(
        to place: Place, producing tokens: Marking, curvedBy curvature: CGFloat = 0) -> Arc
    {
        let arc = Arc(from: self, to: place, labeled: tokens, curvedBy: curvature)
        self.postconditions.append(arc)
        return arc
    }

    // MARK: Firing

    func fire() -> Bool {
        // Check the preconditions of the transition.
        for precondition in self.preconditions {
            if !(precondition.marking <= precondition.place.marking) {
                self.node.report(firingResult: .failure)
                return false
            }
        }

        // Consume the preconditions.
        for precondition in self.preconditions {
            precondition.place >> precondition.marking
        }

        // Produce the postconditions.
        for postcondition in self.postconditions {
            postcondition.place << postcondition.marking
        }

        self.node.report(firingResult: .success)
        return true
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }

}

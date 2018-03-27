//
//  Arc.swift
//  Petri
//
//  Created by Dimitri Racordon on 25.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import GameplayKit


/**
    An arc from a place to a transition (or reversely) of a Petri Net model.

    The `Arc` class represents an at the abstract level. It is mapped to a
    visual representation that can be attached to a scene.
 */
class Arc: GKEntity {

    let place: Place
    let transition: Transition
    let marking: Marking

    init(
        between place: Place, and transition: Transition, labeled marking: Marking,
        drawnWith sprite: ArcSprite)
    {
        self.place = place
        self.transition = transition
        self.marking = marking

        super.init()

        self.addComponent(GKSKNodeComponent(node: sprite))
    }

    convenience init(
        from place: Place, to transition: Transition, labeled marking: Marking,
        curvedBy curvature: CGFloat = 0)
    {
        let sprite = ArcSprite(from: place.node, to: transition.node, curvedBy: curvature)
        sprite.label = marking

        self.init(between: place, and: transition, labeled: marking, drawnWith: sprite)
    }

    convenience init(
        from transition: Transition, to place: Place, labeled marking: Marking,
        curvedBy curvature: CGFloat = 0)
    {
        let sprite = ArcSprite(from: transition.node, to: place.node, curvedBy: curvature)
        sprite.label = marking

        self.init(between: place, and: transition, labeled: marking, drawnWith: sprite)
    }

    var node: ArcSprite {
        return self.component(ofType: GKSKNodeComponent.self)!.node as! ArcSprite
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }

}

//
//  MarkingObjective.swift
//  Petri
//
//  Created by Dimitri Racordon on 30.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


fileprivate let pointerSpriteSize = CGSize(width: 32, height: 32)
fileprivate let checkSpriteSize   = CGSize(width: 24, height: 24)
fileprivate let tokenSpriteSize   = CGSize(width: 24, height: 24)


/**
    An objective on the marking of a particular place.

    Marking objectives require the user to reach a given marking in a
    particular place. They are met whenever such marking is reached, or unmet
    otherwise.

    They are mapped to a visual representation that shows a small label above
    the place indicating the objective.
 */
struct MarkingObjective: Objective {

    unowned let place: Place
    let marking: Marking

    private let handle = SKNode()
    private let pointer: SKSpriteNode

    private let checkMark: SKSpriteNode
    private let label = SKNode()

    init(on place: Place, marking: Marking, observer: @escaping (ObjectiveState) -> ()) {
        self.place = place
        self.marking = marking
        self.observer = observer

        // Initialize the objective visual representation.
        self.handle.position.y = self.place.node.size.height / 2 + 8
        self.place.node.addChild(self.handle)

        self.pointer = SKSpriteNode(
            texture: SKTexture(imageNamed: "Shapes/Pointer"),
            size: pointerSpriteSize)
        self.pointer.zRotation = CGFloat.pi
        self.pointer.position.y = 16
        self.handle.addChild(self.pointer)

        self.checkMark = SKSpriteNode(
            texture: SKTexture(imageNamed: "Icons/Check"),
            size: tokenSpriteSize)
        self.checkMark.position.y = checkSpriteSize.height / 2 + pointerSpriteSize.height + 4
        self.checkMark.alpha = 0
        self.handle.addChild(self.checkMark)

        let spacing = tokenSpriteSize.width + 2
        self.label.position.x = -CGFloat(marking.count - 1) * spacing / 2
        self.label.position.y = tokenSpriteSize.height / 2 + pointerSpriteSize.height + 4
        self.handle.addChild(self.label)

        for (index, token) in marking.enumerated() {
            let sprite = TokenSprite(token, size: tokenSpriteSize, withPhysicsBody: false)
            sprite.position.x = CGFloat(index) * spacing
            self.label.addChild(sprite)
        }

        // Update the visual representation with the current state.
        self.update()

        // Repeatedly move the objective marker up and down.
        self.handle.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: 0, y: 5, duration: 1),
            SKAction.moveBy(x: 0, y: -5, duration: 1)
        ])))
    }

    init(on place: Place, marking: Marking) {
        self.init(on: place, marking: marking, observer: { _ in })
    }

    // MARK: Objective protocol

    var observer: (ObjectiveState) -> Void

    var state: ObjectiveState = .unmet {
        didSet {
            if oldValue != self.state {
               self.observer(self.state)
            }
        }
    }

    mutating func update() {
        // Note that a marking objective can never "fail".
        self.state = (self.marking == self.place.marking) ? .met : .unmet

        // If the objective has been met, show a check mark.
        if self.state == .met {
            if self.label.alpha > 0 {
                self.label.run(SKAction.fadeOut(withDuration: 0.5))
                self.checkMark.run(SKAction.fadeIn(withDuration: 0.5))
            }
            return
        } else {
            if self.label.alpha == 0 {
                self.label.run(SKAction.fadeIn(withDuration: 0.5))
                self.checkMark.run(SKAction.fadeOut(withDuration: 0.5))
            }
        }

        // Determine the multiset of missing tokens.
        var missing = self.marking - self.place.marking

        // Update the objective label.
        for sprite in self.label.children.flatMap({ $0 as? TokenSprite }) {
            if missing.contains(sprite.value) {
                sprite.alpha = 0.3
                missing.remove(sprite.value)
            } else {
                sprite.alpha = 1
            }
        }
    }

    mutating func clean() {
        self.handle.removeFromParent()
    }

}

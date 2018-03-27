//
//  Place.swift
//  Petri
//
//  Created by Dimitri Racordon on 25.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit
import GameplayKit


/**
    A place of a Petri Net model.

    The `Place` class represents a place at the abstract level. It is mapped
    to a visual representation that can be attached to a scene.
 */
class Place: GKEntity {

    init(marking: Marking = [], sprite: PlaceSprite, tokenSpriteSize: CGSize? = nil) {
        self.tokenSpriteSize = tokenSpriteSize ?? sprite.size / 4

        super.init()

        self.addComponent(GKSKNodeComponent(node: sprite))
        self.addComponent(TokenBoxComponent())

        for token in marking {
            self.add(token)
        }
    }

    convenience init(
        marking: Marking = [], spriteSize: CGSize? = nil, tokenSpriteSize: CGSize? = nil)
    {
        var sprite: PlaceSprite?

        if let s = spriteSize {
            sprite = PlaceSprite(size: s)
        } else {
            sprite = PlaceSprite()
        }

        self.init(marking: marking, sprite: sprite!, tokenSpriteSize: tokenSpriteSize)
    }

    var node: PlaceSprite {
        return self.component(ofType: GKSKNodeComponent.self)!.node as! PlaceSprite
    }

    // MARK: Token management

    var marking = Marking()

    let tokenSpriteSize: CGSize

    private var tokenSprites = [Token: [TokenSprite]]()

    func add(_ token: Token) {
        self.marking.insert(token)

        // Create a sprite for the new token at a random position within the place.
        let radius = self.node.size.width * 0.4
        let distance = CGFloat(arc4random_uniform(UInt32(radius)))
        let angle = CGFloat(arc4random_uniform(360)) * CGFloat.pi / 180

        let sprite = TokenSprite(token, size: self.tokenSpriteSize)
        sprite.position = CGPoint(
            x: distance * cos(angle),
            y: distance * sin(angle))
        self.component(ofType: GKSKNodeComponent.self)!.node.addChild(sprite)

        if let sprites = self.tokenSprites[token] {
            self.tokenSprites[token] = sprites + [sprite]
        } else {
            self.tokenSprites[token] = [sprite]
        }

        // Animate the creation of the token.
        sprite.run(sprite.makeCreateAction())
        sprite.physicsBody?.applyImpulse(CGVector(dx: cos(angle), dy: sin(angle)))

        // Register the sprite's physics body to the token box.
        self.component(ofType: TokenBoxComponent.self)!.tokenBodies.append(sprite.physicsBody!)
    }

    func remove(_ token: Token) {
        self.marking.remove(token)

        guard let sprite = self.tokenSprites[token]?.first else {
            return
        }

        sprite.run(sprite.makeDestroyAction())
        let tokenBox = self.component(ofType: TokenBoxComponent.self)!
        tokenBox.tokenBodies = tokenBox.tokenBodies.filter {
            $0 !== sprite.physicsBody
        }

        self.tokenSprites[token]!.removeFirst()
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }

}


func << (place: Place, marking: Marking) {
    for token in marking {
        place.add(token)
    }
}


func >> (place: Place, marking: Marking) {
    for token in marking {
        place.remove(token)
    }
}


class TokenBoxComponent: GKComponent {

    fileprivate var tokenBodies = [SKPhysicsBody]()

    private var shakeObserver: NSObjectProtocol? = nil

    override init() {
        super.init()

        // Register a notification handler for shake events.
        self.shakeObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: Constants.notificationKeys.shakeTokens),
            object: nil,
            queue: nil) {
                notification in
                for body in self.tokenBodies {
                    let angle = CGFloat(arc4random_uniform(360)) * CGFloat.pi / 180
                    body.applyImpulse(CGVector(dx: cos(angle), dy: sin(angle)))
                }
        }
    }

    deinit {
        if shakeObserver != nil {
            NotificationCenter.default.removeObserver(shakeObserver!)
        }
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

}

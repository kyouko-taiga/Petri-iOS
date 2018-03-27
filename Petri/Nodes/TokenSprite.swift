//
//  TokenSprite.swift
//  Petri
//
//  Created by Dimitri Racordon on 26.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


class TokenSprite: SKSpriteNode {

    let value: Token
    let label: SKLabelNode

    init(_ value: Token, size: CGSize, withPhysicsBody: Bool = true) {
        self.value = value
        self.label = SKLabelNode(text: value.displayText)

        let texture = SKTexture(imageNamed: "Shapes/Place")
        super.init(texture: texture, color: SKColor.clear, size: size)

        self.label.fontName = Constants.editor.labels.defaultFontName
        self.label.fontSize = self.size.width * 0.75
        self.label.color = SKColor.black
        self.label.horizontalAlignmentMode = .center
        self.label.verticalAlignmentMode = .center
        self.label.zPosition = self.zPosition + 1
        self.addChild(self.label)

        if withPhysicsBody {
            self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.friction = 0
            self.physicsBody?.linearDamping = 0
            self.physicsBody?.angularDamping = 0
            self.physicsBody?.restitution = 0.75
        }
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }

    // MARK: Creation/destruction animations

    func makeCreateAction(duration: TimeInterval = 0.5) -> SKAction {
        return SKAction.run {
            self.setScale(0.1)
            self.run(SKAction.scale(to: 1, duration: duration))
        }
    }

    func makeDestroyAction(duration: TimeInterval = 0.5) -> SKAction {
        return SKAction.run {
            self.run(SKAction.scale(to: 0.1, duration: duration)) {
                self.removeFromParent()
            }
        }
    }

}

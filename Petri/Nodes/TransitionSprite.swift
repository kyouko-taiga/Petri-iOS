//
//  TransitionSprite.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


class TransitionSprite: SKSpriteNode, Anchor {

    init(size: CGSize = CGSize(width: 64, height: 64)) {
        super.init(
            texture: SKTexture(imageNamed: "Shapes/Transition"),
            color: SKColor.clear,
            size: size)
    }

    // MARK: UI/UX interactions

    enum FiringResult {
        case success, failure
    }

    func report(firingResult: FiringResult) {
        switch firingResult {
        case .success:
            self.run(SKAction.sequence([
                SKAction.colorize(with: SKColor.blue, colorBlendFactor: 0.5, duration: 0.1),
                SKAction.colorize(with: SKColor.clear, colorBlendFactor: 0, duration: 0.1)
            ]))

        case .failure:
            self.run(SKAction.sequence([
                SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.5, duration: 0.1),
                SKAction.colorize(with: SKColor.clear, colorBlendFactor: 0, duration: 0.1)
            ]))
            self.run(SKAction.sequence([
                SKAction.moveBy(x: -3, y: 0, duration: 0.05),
                SKAction.moveBy(x: 6, y: 0, duration: 0.05),
                SKAction.moveBy(x: -6, y: 0, duration: 0.05),
                SKAction.moveBy(x: 3, y: 0, duration: 0.05)
            ]))
        }
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }

}

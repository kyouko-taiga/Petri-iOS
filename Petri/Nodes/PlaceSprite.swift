//
//  PlaceSprite.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


class PlaceSprite: SKSpriteNode, Anchor {

    init(size: CGSize = CGSize(width: 128, height: 128)) {
        super.init(
            texture: SKTexture(imageNamed: "Shapes/Place"),
            color: SKColor.clear,
            size: size)

        // Create the physics body of the place, so that its token can float inside.
        let r = self.size.height / 2
        let x = sqrt(r * r / 2)

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: r))
        path.addLine(to: CGPoint(x: x, y: x))
        path.addLine(to: CGPoint(x: r, y: 0))
        path.addLine(to: CGPoint(x: x, y: -x))
        path.addLine(to: CGPoint(x: 0, y: -r))
        path.addLine(to: CGPoint(x: -x, y: -x))
        path.addLine(to: CGPoint(x: -r, y: 0))
        path.addLine(to: CGPoint(x: -x, y: x))
        path.closeSubpath()
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
    }

    // MARK: Anchor

    func edge(at angle: CGFloat) -> CGPoint {
        return CGPoint(
            x: (self.size.width / 2) * cos(angle * CGFloat.pi / 180),
            y: (self.size.height / 2) * sin(angle * CGFloat.pi / 180)) + self.position
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }

}

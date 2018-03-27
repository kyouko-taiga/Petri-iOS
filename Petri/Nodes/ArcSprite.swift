//
//  ArcSprite.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


class ArcSprite: SKNode {

    init(from: CGPoint, to: CGPoint, curvedBy curvature: CGFloat = 0) {
        super.init()

        self.addChild(self.labelNode)

        // Compute the distance between the two end points.
        let distance = from.distance(to: to)

        // Add the arrow head to the arc node.
        let headSize = self.lineWidth * 8
        self.head = SKSpriteNode(
            texture: SKTexture(imageNamed: "Shapes/Pointer"),
            size: CGSize(width: headSize, height: headSize))
        self.head.anchorPoint.y = 1
        self.head.position = CGPoint(x: distance / 2, y: 0)
        self.head.colorBlendFactor = 1
        self.head.color = self.strokeColor
        self.head.zRotation = -CGFloat.pi / 2
        self.addChild(self.head)

        switch curvature {
        case 0:
            // Create the shaft as a straight line..
            let line = SKSpriteNode(
                texture: SKTexture(imageNamed: "Shapes/Line"),
                size: CGSize(width: distance - headSize / 2, height: self.lineWidth))
            line.position.x -= headSize / 4
            line.color = self.strokeColor
            line.colorBlendFactor = 1
            self.shaft = line

            // Set the default position of the label node.
            self.labelNode.position.y = 16

        case let betaInDegree:
            // Compute the path of the arrow shaft.
            let beta = -betaInDegree * CGFloat.pi / 180
            let handle = CGPoint(x: 0, y: (distance / 2) * tan(beta))
            let offset = CGPoint(x: -headSize / 2 * cos(-beta), y: -headSize / 2 * sin(-beta))

            let path = CGMutablePath()
            path.move(to: CGPoint(x: -distance / 2, y: 0))
            path.addQuadCurve(to: CGPoint(x: distance / 2, y: 0) + offset, control: handle)

            // Implementation note:
            // Note that using too many SKShapeNodes might impact negatively the performances.
            // Unfortunately, as I haven't been able to reproduce its functionality satisfactorily
            // (see the documentation of ShapeTextureNode), I see no other choice than.

            self.shaft = SKShapeNode(path: path)

            // Update the rotation of the head so that it aligns with the curvature of the shaft.
            head.zRotation -= beta

            // Set the default position of the label node.
            self.labelNode.position.y = handle.y / 2 + (beta > 0 ? 16 : -16)
        }

        self.addChild(self.shaft)

        // Compute the rotation and position of the arc.
        self.zRotation = to.angle(to: from)

        if to.x < from.x {
            self.labelNode.zRotation = CGFloat.pi
        }

        let delta = from - to
        let center = CGPoint(
            x: min(from.x, to.x) + abs(delta.x) / 2,
            y: min(from.y, to.y) + abs(delta.y) / 2)
        self.position = center
    }

    convenience init(from: Anchor, to: Anchor, curvedBy curvature: CGFloat = 0) {
        let alpha = from.position.angle(to: to.position) * 180 / CGFloat.pi
        let beta = to.position.angle(to: from.position) * 180 / CGFloat.pi
        let exitPoint = from.edge(at: beta + -curvature)
        let entryPoint = to.edge(at: alpha + curvature)

        self.init(from: exitPoint, to: entryPoint, curvedBy: curvature)
    }

    // MARK: Stroke properties

    private var shaft: SKNode! = nil
    private var head: SKSpriteNode! = nil

    var lineWidth: CGFloat = 2 {
        didSet {
            self.head.size = CGSize(width: self.lineWidth * 8, height: self.lineWidth * 8)
            if let shaft = self.shaft as? SKSpriteNode {
                shaft.size.height = self.lineWidth
            } else if let shaft = self.shaft as? SKShapeNode {
                shaft.lineWidth = self.lineWidth
            }
        }
    }

    var strokeColor: SKColor = .white {
        didSet {
            self.head.color = self.strokeColor
            if let shaft = self.shaft as? SKSpriteNode {
                shaft.color = self.strokeColor
            } else if let shaft = self.shaft as? SKShapeNode {
                shaft.strokeColor = self.strokeColor
            }
        }
    }

    // MARK: Arc labeling

    private let labelNode = SKNode()

    var label: Marking {
        get {
            // Retrieve the value associated with all TokenSprite children.
            return Marking(self.labelNode.children.flatMap { ($0 as? TokenSprite)?.value })
        }

        set(marking) {
            self.labelNode.removeAllChildren()

            let w = 13 * (marking.count - 1)
            for (index, token) in marking.enumerated() {
                let tokenSprite = TokenSprite(
                    token,
                    size: CGSize(width: 24, height: 24),
                    withPhysicsBody: false)
                tokenSprite.position.x = CGFloat(index * 26 - w)
                self.labelNode.addChild(tokenSprite)
            }
        }
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }

}

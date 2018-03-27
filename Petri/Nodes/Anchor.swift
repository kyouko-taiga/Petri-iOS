//
//  Anchor.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


protocol Anchor {

    var position: CGPoint { get }
    var size: CGSize { get }

    func edge(at angle: CGFloat) -> CGPoint

}


extension Anchor {

    func edge(at angle: CGFloat) -> CGPoint {
        let alpha = angle * CGFloat.pi / 180

        switch angle {
        case _ where angle < 0:
            let p = self.edge(at: -angle)
            return CGPoint(x: p.x, y: -p.y + 2 * self.position.y)

        case _ where angle < 45:
            return self.position + CGPoint(
                x: self.size.width / 2,
                y: self.size.width / 2 * tan(alpha))

        case _ where angle < 135:
            return self.position + CGPoint(
                x: self.size.height / 2 * tan(CGFloat.pi / 2 - alpha),
                y: self.size.height / 2)

        case _ where angle <= 180:
            return self.position + CGPoint(
                x: -self.size.width / 2,
                y: self.size.width / 2 * tan(CGFloat.pi - alpha))

        default:
            return self.edge(at: angle - 360)
        }
    }

}

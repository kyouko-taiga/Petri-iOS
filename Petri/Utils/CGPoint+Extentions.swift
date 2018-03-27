//
//  CGPoint+Extentions.swift
//  Petri
//
//  Created by Dimitri Racordon on 26.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


extension CGPoint {

    public func distance(to other: CGPoint) -> CGFloat {
        let delta = self - other
        return sqrt(delta.x * delta.x + delta.y * delta.y)
    }

    public func angle(to other: CGPoint) -> CGFloat {
        let delta = self - other
        return atan2(delta.y, delta.x)
    }

}


public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}


public func += (left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}


public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}


public func -= (left: inout CGPoint, right: CGPoint) {
    left.x -= right.x
    left.y -= right.y
}


public func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}


public func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

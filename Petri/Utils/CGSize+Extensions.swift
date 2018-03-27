//
//  CGSize+Extensions.swift
//  Petri
//
//  Created by Dimitri Racordon on 25.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


public func * (size: CGSize, scalingFactor: CGFloat) -> CGSize {
    return CGSize(
        width: size.width * scalingFactor,
        height: size.height * scalingFactor)
}


public func / (size: CGSize, scalingFactor: CGFloat) -> CGSize {
    return CGSize(
        width: size.width / scalingFactor,
        height: size.height / scalingFactor)
}

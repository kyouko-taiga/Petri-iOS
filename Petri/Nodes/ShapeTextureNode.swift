//
//  ShapeTextureNode.swift
//  Petri
//
//  Created by Dimitri Racordon on 26.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


/**
 * A node that renders a path as a texture, before applying it to a SKSpriteNode.
 *
 * As the Apple documentation states, SKShapeNode offers far less performances than SKSpriteNode.
 * Hence, the latter should be preferred. However, the inability to work with dynamically created
 * paths (including Bezier curves) can be problematic in some cases.
 *
 * ShapeTextureNode tries to address this issue by rendering the given path into a texture, to use
 * SKSpriteNode under the hood.
 *
 * @remark
 * Note that paths rendered with ShapeTextureNode sometimes appear blurry and I haven't been able
 * to fix this yet. According to a plethora of SO posts, this might have to do with scaling and
 * rasterization.
 */
class ShapeTextureNode: SKSpriteNode {

    var path: CGPath

    var lineWidth = CGFloat(1.0)
    var fillColor = SKColor.clear
    var strokeColor = SKColor.clear

    private var shapeLayer = CAShapeLayer()

    init(
        path: CGPath,
        lineWidth: CGFloat = 1.0,
        fillColor: SKColor = SKColor.clear,
        strokeColor: SKColor = SKColor.clear)
    {
        self.path = path
        self.lineWidth = lineWidth
        self.fillColor = fillColor
        self.strokeColor = strokeColor

        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)

        self.redraw()
    }

    func redraw() {
        self.shapeLayer.lineWidth = self.lineWidth
        self.shapeLayer.fillColor = self.fillColor.cgColor
        self.shapeLayer.strokeColor = self.strokeColor.cgColor

        self.shapeLayer.shouldRasterize = true
        self.shapeLayer.contentsScale = UIScreen.main.scale * 2
        self.shapeLayer.rasterizationScale = UIScreen.main.scale * 2

        // Translate the given path so that it's enclosed within positive coordinates only.
        let enclosure = self.path.boundingBoxOfPath
        let offset = CGPoint(
            x: enclosure.origin.x - self.lineWidth,
            y: enclosure.origin.y - self.lineWidth)
        var transform = CGAffineTransform(translationX: -offset.x, y: -offset.y)
        self.shapeLayer.path = self.path.copy(using: &transform)

        // Initialize a context to generate the texture image.
        let textureSize = CGSize(
            width: enclosure.size.width + self.lineWidth * 2,
            height: enclosure.size.height + self.lineWidth * 2)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(
            data: nil,
            width: Int(textureSize.width),
            height: Int(textureSize.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        guard (context != nil) else {
            return
        }

        // Render the CALayer to an image and use it as the node texture.
        self.shapeLayer.render(in: context!)
        if let image = context!.makeImage() {
            let texture = SKTexture(cgImage: image)
            self.texture = texture
            self.size = texture.size()
        }
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        // TODO: Implement NSCoding.
        fatalError("NSCoding not supported on this class")
    }
    
}


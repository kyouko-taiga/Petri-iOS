//
//  Constants.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit


struct Constants {

    struct editor {

        static let defaultBackgroundColor = SKColor(
            red: 190.0 / 255.0,
            green: 226.0 / 255.5,
            blue: 254.0 / 255.0,
            alpha: 1)

        struct labels {
            static let defaultFontName = "Symbol"
            static let defaultFontSize = CGFloat(32)
        }

    }

    struct notificationKeys {
        static let changeScene = "ch.unige.smv.Petri.changeScene"

        static let shakeTokens = "ch.unige.smv.Petri.shakeTokens"
    }

}

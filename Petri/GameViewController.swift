//
//  GameViewController.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as! SKView? else {
            return
        }

        let scene = PuzzleExample(size: view.frame.size)

        view.presentScene(scene)

        view.ignoresSiblingOrder = true

        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = false

        // Register a notification handler for scene transitions.
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: Constants.notificationKeys.changeScene),
            object: nil,
            queue: nil) { notification in
                guard let view = self.view as! SKView? else {
                    return
                }

                let userInfo = notification.userInfo as? [String: PuzzleScene.Type]
                guard let sceneClass = userInfo?["sceneClass"] else {
                    return
                }

                let scene = sceneClass.init(size: view.frame.size)
                view.presentScene(scene, transition: .push(with: .left, duration: 0.5))
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == UIEventSubtype.motionShake {
            // Dispatch a "shakeTokens" message whenever a shake of the device is detected.
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: Constants.notificationKeys.shakeTokens),
                object: nil)
        }
    }

}

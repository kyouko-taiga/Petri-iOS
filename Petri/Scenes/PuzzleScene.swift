//
//  PuzzleScene.swift
//  Petri
//
//  Created by Dimitri Racordon on 24.01.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//

import SpriteKit
import GameplayKit


class PuzzleScene: SKScene, EventDispatcher {

    // MARK: Scene initialization

    override required init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    final override func sceneDidLoad() {
        // Reset the last update time, to compute entities' update.
        self.lastUpdateTime = 0

        // Set the scene background.
        self.backgroundColor = Constants.editor.defaultBackgroundColor

        // Create the puzzle.
        self.createModel()
        self.modelNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(self.modelNode)

        // Create the scene camera.
        let camera = SKCameraNode()
        camera.position = self.modelNode.position
        self.addChild(camera)
        self.camera = camera
    }

    final override func didMove(to view: SKView) {
        // Create gesture recognizers for UI interactions.
        self.panRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(self.handlePanGesture))
        view.addGestureRecognizer(self.panRecognizer)

        let pinchRecognizer = UIPinchGestureRecognizer(
            target: self, action: #selector(self.handleZoomGesture))
        view.addGestureRecognizer(pinchRecognizer)
    }

    deinit {
        // Remove all event observers.
        self.eventObservers.removeAll()
    }

    // MARK: Gameplay

    private var eventObservers = [EventObserver]()

    @discardableResult
    func addEventObserver(using block: @escaping (Event) -> ()) -> EventObserver {
        let observer = EventObserver(block)
        self.eventObservers.append(observer)
        return observer
    }

    func removeEventObserver(_ observer: EventObserver) {
        if let index = self.eventObservers.index(where: { $0 === observer }) {
            self.eventObservers.remove(at: index)
        }
    }

    func dispatchEvent(_ event: Event) {
        for observer in self.eventObservers {
            observer.notify(event)
        }
    }

    final var objectives = [Objective]()

    final func addObjective(_ objective: Objective) {
        self.objectives.append(objective)
    }

    // MARK: Model management

    final var entities = [GKEntity]()

    private var modelNode = SKNode()

    final func addEntity(_ entity: GKEntity) {
        self.entities.append(entity)

        // Automatically add the entity's node to the scene if it uses GKSKNodeComponent.
        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
            self.modelNode.addChild(node)
        }
    }

    @discardableResult
    final func makePlace(
        marking: Marking, at position: CGPoint,
        size: CGSize? = nil, tokenSize: CGSize? = nil) -> Place
    {
        let place = Place(marking: marking, spriteSize: size, tokenSpriteSize: tokenSize)
        place.node.position = position
        self.addEntity(place)

        return place
    }

    @discardableResult
    final func makeTransition(
        conditions: [PartialArcDefinition] = [],
        at position: CGPoint, size: CGSize? = nil) -> Transition
    {
        let transition = Transition(spriteSize: size)
        transition.node.position = position
        self.addEntity(transition)

        for arcDef in conditions {
            var arc: Arc?

            switch arcDef.direction {
            case .pre:
                arc = transition.pre(
                    from: arcDef.place, consuming: arcDef.marking, curvedBy: arcDef.curvature)
            case .post:
                arc = transition.post(
                    to: arcDef.place, producing: arcDef.marking, curvedBy: arcDef.curvature)
            }

            arc!.node.lineWidth = arcDef.lineWidth
            arc!.node.strokeColor = arcDef.color
            self.addEntity(arc!)
        }

        return transition
    }

    struct PartialArcDefinition {

        enum Direction {
            case pre, post
        }

        let direction: Direction

        let place: Place
        let marking: Marking

        let curvature: CGFloat
        let lineWidth: CGFloat
        let color: SKColor
        
    }

    final func arc(
        from place: Place, consuming marking: Marking,
        curvedBy curvature: CGFloat = 0,
        thickenedBy lineWidth: CGFloat = 1,
        coloredWith color: SKColor = .white) -> PartialArcDefinition
    {
        return PartialArcDefinition(
            direction: .pre, place: place, marking: marking,
            curvature: curvature, lineWidth: lineWidth, color: color)
    }

    final func arc(
        to place: Place, producing marking: Marking,
        curvedBy curvature: CGFloat = 0,
        thickenedBy lineWidth: CGFloat = 1,
        coloredWith color: SKColor = .white) -> PartialArcDefinition
    {
        return PartialArcDefinition(
            direction: .post, place: place, marking: marking,
            curvature: curvature, lineWidth: lineWidth, color: color)
    }

    func createModel() {}

    // MARK: User interactions

    final func transitionTo(sceneClass: PuzzleScene.Type) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Constants.notificationKeys.changeScene),
            object: nil,
            userInfo: ["sceneClass": sceneClass])
    }

    final var isPanningEnabled = true

    private var panRecognizer: UIPanGestureRecognizer! = nil
    private var cameraPositionBeforePanning: CGPoint! = nil
    private var modelFrame: CGRect! = nil

    final func handlePanGesture(sender gesture: UIPanGestureRecognizer) {
        if !self.isPanningEnabled {
            return
        }

        if self.panRecognizer.state == .began {
            self.cameraPositionBeforePanning = self.camera?.position
            self.modelFrame = self.modelNode.calculateAccumulatedFrame()
        }

        guard
            let camera = self.camera,
            let view = self.view
        else {
            return
        }

        // Compute the new position of the camera.
        let translation = gesture.translation(in: view)
        var newPosition = CGPoint(
            x: self.cameraPositionBeforePanning.x - translation.x,
            y: self.cameraPositionBeforePanning.y + translation.y)

        // Constrain the translation of the camera so that the model always stays in the viewport.
        newPosition.x = max(newPosition.x, self.modelFrame!.minX)
        newPosition.x = min(newPosition.x, self.modelFrame!.maxX)
        newPosition.y = max(newPosition.y, self.modelFrame!.minY)
        newPosition.y = min(newPosition.y, self.modelFrame!.maxY)

        camera.position = newPosition
    }

    final var isZoomingEnabled = true

    final func handleZoomGesture(sender gesture: UIPinchGestureRecognizer) {
        if !self.isZoomingEnabled {
            return
        }

        guard let camera = self.camera else {
            return
        }

        let zoom = min(max(gesture.scale, 1), 2)
        camera.setScale(zoom)
    }

    final override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        for node in self.nodes(at: touch.location(in: self)) {
            if let transition = (node as? TransitionSprite)?.entity as? Transition {
                if transition.fire() {
                    // Update all scene objectives when the state of the model changes.
                    for i in self.objectives.indices {
                        self.objectives[i].update()
                    }

                    // Dispatch a transitionFired event.
                    self.dispatchEvent(.transitionFired(transition: transition))
                }
            }
        }
    }

    // MARK: Game loop

    private var lastUpdateTime: TimeInterval = 0

    final override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }

}

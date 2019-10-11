//
//  ViewController.swift
//  SpriteKitAnimationsExample
//
//  Created by Andrew Konovalskiy
//  Copyright © 2019 Andrew Konovalskiy. All rights reserved.
//

import UIKit
import SpriteKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private let animationView = SKView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(animationView)
        let scene = makeScene()
        animationView.frame.size = scene.size
        animationView.presentScene(scene)
        createSceneContents(for: scene)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        animationView.center.x = view.bounds.midX
        animationView.center.y = view.bounds.midY
    }
}

// MARK: - Private methods
private extension ViewController {
    
    func addEmoji(to scene: SKScene) {
        
        let allEmoji: [Character] = ["🍊", "🍋", "🍑", "🥭"]
        let distance = floor(scene.size.width / CGFloat(allEmoji.count))
        
        for (index, emoji) in allEmoji.enumerated() {
            let node = SKLabelNode()
            node.renderEmoji(emoji)
            node.position.y = floor(scene.size.height / 2)
            node.position.x = distance * (CGFloat(index) + 0.5)
            scene.addChild(node)
        }
    }
    
    func makeScene() -> SKScene {
        
        let minimumDimension = min(view.frame.width, view.frame.height)
        let size = CGSize(width: minimumDimension, height: minimumDimension)
        let scene = SKScene(size: size)
        scene.backgroundColor = .white
        addEmoji(to: scene)
        animateNodes(scene.children)
        return scene
    }
    
    func animateNodes(_ nodes: [SKNode]) {
        for (index, node) in nodes.enumerated() {
            node.run(.sequence([
                .wait(forDuration: TimeInterval(index) * 0.2),
                .repeatForever(.sequence([
                    // A group of actions get performed simultaneously
                    .group([
                        .sequence([
                            .scale(to: 1.5, duration: 0.3),
                            .scale(to: 1, duration: 0.3)
                            ]),
                        // Rotate by 360 degrees (pi * 2 in radians)
                        .rotate(byAngle: .pi * 2, duration: 0.6)
                        ]),
                    .wait(forDuration: 2)
                    ]))
                ]))
        }
    }
    
    func createSceneContents(for scene: SKScene) {
        let defaultNumberOfWalkFrames: Int = 28
        let characterFramesOverOneSecond: TimeInterval = 1.0 / TimeInterval(defaultNumberOfWalkFrames)
        let walkFrames = animationFrames(forImageNamePrefix: "warrior_walk_",
                                         frameCount: defaultNumberOfWalkFrames)
        
        // Create the sprite with the initial frame.
        let sprite = SKSpriteNode(texture: walkFrames.first)
        sprite.position = CGPoint(x: animationView.frame.midX,
                                  y: animationView.frame.midY + 60)
        scene.addChild(sprite)
        
        // Cycle through the frames.
        let animateFramesAction: SKAction = .animate(with: walkFrames,
                                                     timePerFrame: characterFramesOverOneSecond,
                                                     resize: true,
                                                     restore: false)
        let rotate: SKAction = .rotate(byAngle: .pi / 2, duration: 0.3)
        let newPosition: CGFloat = 100
        let moveDuration: TimeInterval = 1.0
        sprite.run(.repeatForever(
            .sequence(
                [.group([ // Move to top
                    animateFramesAction,
                    .moveBy(x: 0.0, y: newPosition, duration: moveDuration)]),
                 rotate,
                 .group([ // Move to left
                    animateFramesAction,
                    .moveBy(x: -newPosition, y: 0.0, duration: moveDuration)]),
                 rotate,
                 .group([ // Move to bottom
                    animateFramesAction,
                    .moveBy(x: 0.0, y: -newPosition, duration: moveDuration)]),
                 rotate,
                 .group([ // Move to right
                    animateFramesAction,
                    .moveBy(x: newPosition, y: 0.0, duration: moveDuration)]),
                 rotate])
            ))
    }

    func animationFrames(forImageNamePrefix baseImageName: String,
                         frameCount count: Int) -> [SKTexture] {
        // Loads a series of frames from files stored in the app Assets, returning them in an array.
        var array = [SKTexture]()
        for index in 1...count {
            let imageName = String(format: "%@%04d.png", baseImageName, index)
            let texture = SKTexture(imageNamed: imageName)
            array.append(texture)
        }
        return array
    }
}

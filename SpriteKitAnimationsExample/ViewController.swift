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
}

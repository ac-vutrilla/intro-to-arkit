//
//  ViewController.swift
//  IntroToAR
//
//  Created by Avenue Code on 11/13/18.
//  Copyright © 2018 Avenue Code. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var focusSquare: FocusSquare?
    var screenCenter: CGPoint!
    var modelInScene: [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Options for drawing overlay content in a scene that can aid debugging
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Automatically adds lights to a scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        // Assign the center point of the view's frame rectangle
        screenCenter = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // New center when screen orientation changed
        let viewCenter = CGPoint(x: size.width / 2, y: size.height / 2)
        screenCenter = viewCenter
    }
    
    func updateFocusSquare() {
        guard let focusSquareLocal = focusSquare else { return }
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let firstVisibleModel = modelInScene.first { (node) -> Bool in
            return sceneView.isNode(node, insideFrustumOf: pointOfView)
        }
        
        let modelsAreVisible = firstVisibleModel != nil
        if modelsAreVisible != focusSquareLocal.isHidden {
            focusSquareLocal.setHidden(to: modelsAreVisible)
        }
        
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        if let hitTestResult = hitTest.first {
            // Focus square hit a plane
            let canAddNewModel = hitTestResult.anchor is ARPlaneAnchor
            focusSquareLocal.isClose = canAddNewModel
        } else {
            // Focus square does not hit a plane
            focusSquareLocal.isClose = false
        }
    }

}

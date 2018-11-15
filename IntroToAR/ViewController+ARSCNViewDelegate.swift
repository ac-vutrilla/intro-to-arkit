//
//  ViewController+ARSCNViewDelegate.swift
//  IntroToAR
//
//  Created by Avenue Code on 11/14/18.
//  Copyright © 2018 Avenue Code. All rights reserved.
//

import SceneKit
import ARKit

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Horizontal surface detected
        guard focusSquare == nil else { return }
        let focusSquareLocal = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquareLocal)
        focusSquare = focusSquareLocal
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let focusSquareLocal = focusSquare else { return }
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlane)
        let hitTestResult = hitTest.first
        
        // Position and orientation of the hit test result
        guard let positionColumn = hitTest.first?.worldTransform.columns.3 else { return }
        focusSquareLocal.position = SCNVector3(positionColumn.x, positionColumn.y, positionColumn.z)
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
    }

}

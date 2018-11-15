//
//  ViewController+ObjectAttach.swift
//  IntroToAR
//
//  Created by Avenue Code on 11/14/18.
//  Copyright © 2018 Avenue Code. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ViewController {
    
    fileprivate func getModel(named name: String) -> SCNNode? {
        let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")
        guard let model = scene?.rootNode.childNode(withName: "SketchUp", recursively: false) else { return nil }
        model.name = name
        
        var scale: CGFloat
        switch name {
        case "AppleWatch":   scale = 0.0000038
        case "iPhone8":      scale = 0.000008
        case "MacBookPro13": scale = 0.0022
        default:             scale = 1
        }
        
        model.scale = SCNVector3(scale, scale, scale)
        return model
    }
    
    @IBAction func addObjectButtonTapped(_ sender: Any) {
        guard focusSquare != nil else { return }
        
        let modelName = "AppleWatch"
        guard let model = getModel(named: modelName) else {
            print("Unable to load \(modelName) from file")
            return
        }
        
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        guard let positionColumn = hitTest.first?.worldTransform.columns.3 else { return }
        model.position = SCNVector3(positionColumn.x, positionColumn.y, positionColumn.z)
        
        sceneView.scene.rootNode.addChildNode(model)
        
        modelInScene.append(model)
    }
}

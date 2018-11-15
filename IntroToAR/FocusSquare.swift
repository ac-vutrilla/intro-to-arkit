//
//  FocusSquare.swift
//  IntroToAR
//
//  Created by Avenue Code on 11/14/18.
//  Copyright © 2018 Avenue Code. All rights reserved.
//

import SceneKit
import ARKit

class FocusSquare: SCNNode {
    
    var isClose: Bool = true {
        didSet {
            geometry?.firstMaterial?.diffuse.contents = self.isClose ? UIImage(named: "FocusSquare/close") : UIImage(named: "FocusSquare/open")
        }
    }

    override init() {
        super.init()
        
        let plane = SCNPlane(width: 0.1, height: 0.1)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "FocusSquare/open")
        plane.firstMaterial?.isDoubleSided = true
        
        geometry = plane
        eulerAngles.x = GLKMathDegreesToRadians(-90)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHidden(to hidden: Bool) {
        var fadeTo: SCNAction
        
        fadeTo = hidden ? .fadeOut(duration: 0.5) : .fadeIn(duration: 0.5)
        
        let actions = [fadeTo, .run({ (focusSquare: SCNNode) in
            focusSquare.isHidden = hidden
        })]
        runAction(.sequence(actions))
    }
}

//
//  SKLabelNode+ShadowLabelNode.swift
//
// A Swift port of Erica Sadun's ShadowLabelNode class.  Released under the Creative Commons 0 (CC0) license.
// Port done by Phillip Brisco
//
// Phillip Brisco - Added removeLabel() function so that user can easily delete all observers on the label before deleting
//                  the label, then delete the label itself.  This way, the user doesn't have to worry about it.
//
import SpriteKit

class ShadowLabelNode : SKLabelNode {
    var offset : CGPoint?;
    var shadowColor : UIColor?
    var blurRadius : CGFloat?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init () {
        super.init()
    }

    // Inital setup for the shadow node (in Objective-C this is the instanceType method)
    override init (fontNamed : String) {
        super.init(fontNamed: fontNamed)

        var standardUserDefaults : NSUserDefaults? = NSUserDefaults.standardUserDefaults();
        var defaultColor : NSNumber? = nil
        
        if (standardUserDefaults != nil) {
            defaultColor = standardUserDefaults!.objectForKey("color") as? NSNumber
        }
        
        var outlineColor = Int();
        
        // If we couldn't get the color, for any reason, assume black as the default.
        if (defaultColor != nil) {
            outlineColor = Int(defaultColor!.intValue)
        } else {
            outlineColor = 1
        }
        
        // Set defaults
        self.fontColor = UIColor.blackColor()
        offset = CGPointMake(0, 0)      // Right and down in default scene
        blurRadius = 3
        
        // Number of the color with which the shadow label node will be blurred.
        switch (outlineColor) {
        case 0:
            shadowColor = UIColor.blackColor()
        case 1:
            shadowColor = UIColor.whiteColor()
        case 2:
            shadowColor = UIColor.redColor()
        case 3:
            shadowColor = UIColor.blueColor()
        case 4:
            shadowColor = UIColor.greenColor()
        case 5:
            shadowColor = UIColor.yellowColor()
        default:
            shadowColor = UIColor.brownColor()
        }
        
        for keyPath in ["text", "fontName", "fontSize", "verticalAlignmentMode", "horizontalAlignmentMode", "fontColor"] {
            self.addObserver(self, forKeyPath: keyPath, options: NSKeyValueObservingOptions.New, context: nil)
        }
        
        self.updateShadow()
    }
    
    func updateShadow () {
        var effectNode : SKEffectNode? = self.childNodeWithName("ShadowEffectNodeKey") as? SKEffectNode
        
        if (effectNode == nil) {
            effectNode = SKEffectNode();
            effectNode!.name = "ShadowEffectNodeKey"
            effectNode!.shouldEnableEffects = true
            effectNode!.zPosition = -1
        }
        
        let filter : CIFilter? = CIFilter (name: "CIGaussianBlur")
        filter?.setDefaults();
        filter?.setValue(blurRadius, forKey: "inputRadius")
        effectNode?.filter = filter
        effectNode?.removeAllChildren()
        
        // Duplicate and offset the label
        var labelNode : SKLabelNode? = SKLabelNode (fontNamed: self.fontName)
        labelNode?.text = self.text
        labelNode?.fontSize = self.fontSize
        labelNode?.verticalAlignmentMode = self.verticalAlignmentMode
        labelNode?.horizontalAlignmentMode = self.horizontalAlignmentMode
        labelNode?.fontColor = shadowColor!     // Shadow not parent color
        labelNode?.position = offset!            // Offset from parent
        
        effectNode!.addChild(labelNode!)
        self.insertChild(effectNode, atIndex: 0)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        self.updateShadow()
    }

    func setOffset (offset : CGPoint) {
        self.updateShadow()
    }

    func setBlurRadius (blurRadius : CGFloat) {
        self.updateShadow()
    }
    
    func setShadowColor (shadowColor : UIColor) {
        self.updateShadow();
    }
    
    func nodeTexture () -> SKTexture {
        return self.scene!.view!.textureFromNode(self)
    }
    
}

extension ShadowLabelNode {
    
    // Removes all of the observers for the shadow node and the label itself.
    func removeLabel () {
        
        for keyPath in ["text", "fontName", "fontSize", "verticalAlignmentMode", "horizontalAlignmentMode", "fontColor"] {
            self.removeObserver(self, forKeyPath: keyPath);
            self.removeFromParent();
        }
        
    }

}

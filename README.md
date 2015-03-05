# ShadowLabelNode
Swift port of Erica Sadun's ShadowLabelNode class

Erica Sadun wrote an article in the "iOS Developer's Cookbook" (July 28, 2014) on how to create a dynamic drop shadow with
special effects for label nodes.  This is the Swift port of her Objective-C class.

I've taken the liberty of adding more functionality to her library.  Specifically, NSUserDefaults is used to pass an index when
creating a shadow that indicates what color the shadow is.  Currently, there are seven options (black, white, red, blue, green,
yellow and brown).  This would be set up in the calling routine with something like:

        let theDefault : NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        
        if (theDefault != nil) {
            theDefault?.setObject(NSNumber(int: shadeYellow), forKey: "color")
        }
          
    so that the ShadowLabelNode knows what color to used (yellow, in this case) followed by the creation of the node with shadow
    
        var lblStart = ShadowLabelNode(fontNamed: "ChalkboardSE-Bold")
        lblStart.fontSize = 60
        lblStart.fontColor = UIColor(red: 1.0/255, green: 34.0/255, blue: 144.0/255, alpha: 1.0)
        lblStart.position = CGPointMake(CGRectGetMidX(selfNode.frame), (selfNode.frame.size.height / 2))
        lblStart.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblStart.text = "Touch Screen to Start"
        lblStart.name = "START"
        lblStart.zPosition = 1
        
    The obervers at instanciation of the shadow node will keep track of any text added dynamically (or statically) and position
    the label's shadow properly in relation to the shadow.  Be aware, though.  This is an expensive operation and not to be used lightly.
    To remove the label, the observers have to be removed first.  The "removeLabel()" function at the end of this class takes
    care of this problem automagically and is called like so:
    
      lblStart.removeLabel()

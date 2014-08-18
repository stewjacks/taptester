//
//  ViewController.swift
//  tapstester
//
//  Created by Stewart Jackson on 2014-08-18.
//  Copyright (c) 2014 Stewart Jackson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct VelocityObject {
        var point: CGPoint
        var time: Double
    }
    
    let threshold:Double = 0.3 // this is in seconds and can possibly be a user setting later
    
    var activeTouches: [Int: [VelocityObject]] = [:]
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        NSLog("touchesBegan")
        
        for touch in touches {
            if let touch = touch as? UITouch {
                NSLog("touchesBegan touch: %@", touch.description)
                activeTouches[touch.hash] = [VelocityObject(point: touch.locationInView(self.view), time: event.timestamp)]
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("touchesMoved")
        for touch in touches {
            if let touch = touch as? UITouch {
                NSLog("touchesMoved touch: %@", touch.description)
                var velocityArray: [VelocityObject] = activeTouches[touch.hash]!
                velocityArray.append(VelocityObject(point: touch.locationInView(self.view), time: event.timestamp))
                activeTouches[touch.hash] = velocityArray
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("touchesEnded")
        for touch in touches {
            if let touch = touch as? UITouch {
                NSLog("touchesEnded touch: %@", touch.description)
                var velocityArray: [VelocityObject] = activeTouches[touch.hash]!
                NSLog("VelocityArray count %i", velocityArray.count)
                //                if velocityArray.count <= 4 {
                self.handleTap(touch as UITouch)
                
                if !velocityArray.isEmpty && velocityArray.count > 4 {
                    checkMotion(velocityArray)
                }
                println("activeTouches before delete \(activeTouches.count)")
                activeTouches.removeValueForKey(touch.hash)
//                activeTouches[touch] = nil
                println("activeTouches after delete \(activeTouches.count)")
            }
        }
    }
    
    func checkMotion(velocityArray: [VelocityObject]) -> Bool {
        
        var duration: Double = 0
        var distance: CGFloat = 0
        var previousPoint: CGPoint?
        var previousDuration: Double?
        //        var swipeDirection:
        
        NSLog("CheckMotion")
        
        for p in velocityArray {
            if previousPoint == nil {
                previousPoint = p.point
            } else {
                distance += sqrt(pow((p.point.x - previousPoint!.x), 2.0) + pow((p.point.y - previousPoint!.y), 2.0))
            }
            if previousDuration == nil {
                previousDuration = p.time
            } else {
                duration += p.time - previousDuration!
            }
            
            
        }
        
        let speed:Double = Double(distance) / duration
        
        NSLog("Speed: %f Distance %f", speed, Float(distance))
        
        //        return (distance/time >= 1 &&
        
        return true
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("KeyboardViewController touchesCancelled")
        
    }
    
    func handleTap(tap: UITouch) {
        var pt = tap.locationInView(self.view)
        NSLog("Called handleTapGesture A x %@ y %@", pt.x.description, pt.y.description)
        
        var bounds = self.view.bounds
        NSLog("Called handleTapGesture B origin: %@", bounds.origin.x.description)
        
        var normalized : Double = (Double(pt.x)  - Double(bounds.origin.x)) / Double(bounds.size.width)
        NSLog("Called handleTapGesture C ")
    }



}


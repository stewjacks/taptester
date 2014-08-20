//
//  ViewController.swift
//  tapstester
//
//  Created by Stewart Jackson on 2014-08-18.
//  Copyright (c) 2014 Stewart Jackson. All rights reserved.
//

import UIKit

enum KeyboardTouchEventType : Printable {
    case Tap(CGPoint)
    case SwipeLeft
    case SwipeRight
    case NoEvent
    
    var description : String {
        get {
            switch self {
            case .Tap(let touch):
                return "tap \(touch)"
            case .SwipeLeft:
                return "swipeLeft"
            case .SwipeRight:
                return "swipeRight"
            case .NoEvent:
                return "noEvent"
            }
        }
    }
}

struct TouchPoint {
    var point: CGPoint
    var time: NSTimeInterval
    
    init(touch: UITouch){
        self.point = touch.locationInView(touch.view)
        self.time = touch.timestamp
    }
}


class ViewController: UIViewController {
        var activeTouches = [Int: [TouchPoint]]()
                            
//    @IBAction func tapAction(sender: UITapGestureRecognizer) {
//        NSLog("tapAction location: %@, %@", sender.locationInView(self.view).x.description, sender.locationInView(self.view).x.description)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.multipleTouchEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    //MARK: handling recognized events
    func handleTapEvent(point: CGPoint) {
        NSLog("Do the tap thing at point %@, %@", point.x.description, point.y.description)
    }
    
    func handleSwipeLeftEvent() {
        NSLog("Do the swipe left thing <--------------")
    }
    
    func handleSwipeRightEvent() {
        NSLog("Do the swipe left thing -------------->")
    }
    
    //MARK: overriding UIKit touch methods
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("touchesBegan")
        
        for touch in touches {
            super.touchesBegan(touches, withEvent: event)
            if let touch = touch as? UITouch {
                
                NSLog("touchesBegan touch: %@", touch.description)
                activeTouches[touch.hash] = [TouchPoint(touch: touch)]
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event)
        NSLog("touchesMoved %i", touches.count)
        for touch in touches {
            if let touch = touch as? UITouch {
                
                NSLog("touchesMoved touch: %@", touch.description)
                var touchPoints: [TouchPoint] = activeTouches[touch.hash]!
                println("delta time: \(touch.timestamp - touchPoints[touchPoints.count-1].time)")
                touchPoints.append(TouchPoint(touch: touch))
                activeTouches[touch.hash] = touchPoints
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("touchesEnded")
        super.touchesEnded(touches, withEvent: event)
        for touch in touches {
            if let touch = touch as? UITouch {
                NSLog("touchesEnded touch: %@", touch.description)
                var touchPoints: [TouchPoint] = activeTouches[touch.hash]!
                NSLog("touchPoints count %i", touchPoints.count)

                handleKeyboardTouchEvent(eventForTouchWithPoints(touchPoints))
                
                println("activeTouches before delete \(activeTouches.count)")
                activeTouches.removeValueForKey(touch.hash)
                println("activeTouches after delete \(activeTouches.count)")
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            activeTouches.removeValueForKey(touch.hash)
        }
            NSLog("KeyboardViewController touchesCancelled")
        
    }
    
//MARK: extracting events from touches
    
    func handleKeyboardTouchEvent(keyboardTouchEventType: KeyboardTouchEventType) {
        switch keyboardTouchEventType {
        case .Tap(let point):
            handleTapEvent(point)
        case .SwipeLeft:
            handleSwipeLeftEvent()
        case .SwipeRight:
            handleSwipeRightEvent()
        case .NoEvent:
            println("received noEvent")
        default:
            break
        }
    }
    
//    this is all adapted more or less verbatim from StrokeAnalyzer.java, comments included
/* Defines time interval from the last touch event on which we want to measure the speed of swipe. (red line in plots) */
//    let VELOCITY_SENSITIVITY_TIME: NSTimeInterval = 0.012;
//    let DISCRIMINANT_SLOPE: Float = -1.0/50; //100 pixels, 2.0 velocity
//    let DISCRIMINANT_YINT: Float = 1.0

//    including this comment:
    /* Handles very short fast strokes which should actually be considered taps
    * This data point (100, 7) defines the anchor point of this discriminant line,
    * which at 0 sensitivity is a vertical discriminant and at 100 sensitivity
    * this discriminant goes through the origin (see blue line in analysis plots) */
//    let DISCRIMINANT_EXTRA_MAX_SPEED: Float = 7.0;
//    let DISCRIMINANT_EXTRA_MAX_SENSITIVITY: Float = 100;
    
//   If stroke was equal or longer than this time we consider input to be reliable input.

//    let RELIABLE_TIME: NSTimeInterval = 0.3;
////    FIXME: this is an arbitrary value. On android this is set dynamically based on device?
//    let SENSITIVITY: Float = 0.012
//    
    
    func checkDiscriminant(
        first:  Float,
        second: Float,
        threshHoldVelocity:     Float = 1.0,
        threshholdDisplacement: Float = 50) -> Bool {
            
        let slope = (-threshHoldVelocity) / threshholdDisplacement
            
//        let y = Float(point.y)
//        let x = Float(point.x)
//        let m: Float = DISCRIMINANT_SLOPE
//        let b: Float = Float(yIntScale) * DISCRIMINANT_YINT
        

//        var sensitivity = fmax(SENSITIVITY, 1)
//        sensitivity = fmin(sensitivity, DISCRIMINANT_EXTRA_MAX_SENSITIVITY)
        
//        let mSensitivity = DISCRIMINANT_EXTRA_MAX_SPEED / sensitivity
//        let bSensitivity: Float = -DISCRIMINANT_EXTRA_MAX_SPEED * (DISCRIMINANT_EXTRA_MAX_SENSITIVITY - mSensitivity) / mSensitivity
        
        if (first > slope * second) && (first < slope * second + threshholdDisplacement) {
            return true
        }
        return false
        
        
    }
    func eventForTouchWithPoints(touches: [TouchPoint]) -> KeyboardTouchEventType {
        if (touches.count >= 2) {
            let first = touches.first!
            let last = touches.last!
            
            let deltaX = fabs(last.point.x - first.point.x)
            let deltaY = fabs(last.point.y - first.point.y)
            
            let duration = last.time
            
            let xVelocity = Float(deltaX) / Float(duration)
            let yVelocity = Float(deltaY) / Float(duration)
            
            if checkDiscriminant(xVelocity, second: Float(deltaX)) {
                if deltaX < 0 {
                    return .SwipeLeft
                }else {
                    return .SwipeRight
                }

            }else if checkDiscriminant(yVelocity, second: Float(deltaY)) {
//                TODO: we can handle vertical swipes here?
                return .NoEvent
            }else{
                return .Tap(touches.last!.point)
            }
            
            
        }
        return .NoEvent
    }

}


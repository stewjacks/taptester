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

struct TouchPoint: Printable{
    var point: CGPoint
    var time: NSTimeInterval
    
    init(touch: UITouch){
        self.point = touch.locationInView(touch.view)
        self.time = touch.timestamp
        println("timestamp \(touch.timestamp.description)")
    }
    
    var description: String {
        get {
            return "\(point), delta time: \(time)"
        }
    }
}

class TouchEvent {
    var points : [TouchPoint]
    let identifier: Int
    
    var count : Int{
        get {
            return points.count
        }
    }

    var first : TouchPoint {
        get {
            return points.first!
        }
    }
    
    var last : TouchPoint {
        get {
            return points.last!
        }
    }
    
    init(point: TouchPoint, identifier: Int) {
        self.points = [point]
        self.identifier = identifier
    }
    
    init(touch: UITouch) {
        points = [TouchPoint(touch: touch)]
        identifier = touch.hash
    }
    
    
    subscript(index: Int) -> TouchPoint {
        return points[index]
    }
    
    
    func add(touch: UITouch) {
        points.append(TouchPoint(touch: touch))
    }
}

extension TouchEvent: Printable, DebugPrintable {
    var description: String {
        get {
            var pointDescription = ""
            for point in self.points {
                pointDescription += "\(point)\n"
            }
            return "Touch event with \(self.count) touchPoints:\n \(pointDescription)"
        }
    }
    
    var debugDescription: String {
        get {
            return ""
        }
    }
}


class ViewController: UIViewController {
        var activeTouches = [Int: TouchEvent]()
                            
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
        NSLog("Do the swipe right thing -------------->")
    }
    
    //MARK: overriding UIKit touch methods
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
//        NSLog("touchesBegan")
        super.touchesBegan(touches, withEvent: event)
        for touch in touches {

            if let touch = touch as? UITouch {
                activeTouches[touch.hash] = TouchEvent(touch: touch)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event)
        NSLog("touchesMoved %i", touches.count)
        for touch in touches {
            if let touch = touch as? UITouch {
                let touchEvent = activeTouches[touch.hash]!
//                println("delta time: \(touch.timestamp - touchPoints[touchPoints.count-1].time)")
                touchEvent.add(touch)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("touchesEnded")
        super.touchesEnded(touches, withEvent: event)
        for touch in touches {
            if let touch = touch as? UITouch {
                let touchEvent = activeTouches[touch.hash]!
                touchEvent.add(touch)
//                NSLog("touchPoints count %i", touchPoints.count)

                handleKeyboardTouchEvent(eventTypeForTouchEvent(touchEvent))
                activeTouches.removeValueForKey(touch.hash)

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
        speed:  Float,
        displacement: Float,
        threshHoldVelocity: Float = 1000.0, // pixels per second
        threshholdDisplacement: Float = 50.0) -> Bool {
        
            let slope = (-threshHoldVelocity) / threshholdDisplacement
            println("first xVelocity \(speed), second Float(deltaX) \(displacement) slope \(slope) thresholdV \(threshHoldVelocity) thresholdD \(threshholdDisplacement)")
            println("check \(slope * displacement + threshHoldVelocity)")
            if (speed > slope * displacement + threshHoldVelocity) {
                return true
            }
            return false
            
        
    }
    func eventTypeForTouchEvent(event: TouchEvent) -> KeyboardTouchEventType {
        if (event.count >= 2) {
            let first = event.first
            let last = event.last
            
            let deltaX = last.point.x - first.point.x
            let deltaY = last.point.y - first.point.y
            
            let duration = last.time - first.time
            
            let xVelocity = Float(deltaX) / Float(duration)
            let yVelocity = Float(deltaY) / Float(duration)
            println("first \(event.first.point) last \(event.last.point) deltaX \(deltaX) deltaY \(deltaY) duration \(duration) xVelocity \(xVelocity) yVelocity \(yVelocity)")
            if checkDiscriminant(abs(xVelocity), displacement: Float(abs(deltaX))) {
                if deltaX < 0 {
                    return .SwipeLeft
                }else {
                    return .SwipeRight
                }

            }else if checkDiscriminant(yVelocity, displacement: Float(deltaY)) {
//                TODO: we can handle vertical swipes here?
                return .NoEvent
            }else{
                return .Tap(event.last.point)
            }
            
            
        }
//        if touches.last != nil {
//            return .Tap(touches.last!.point)
//        }
        //shouldn't happen
        return .NoEvent
    }

}


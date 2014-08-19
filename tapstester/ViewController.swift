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
    var time: Double
    
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

    func eventForTouchWithPoints(touches: [TouchPoint]) -> KeyboardTouchEventType {

        return .NoEvent
    }
    
//        switch KeyboardTouchEventType {
//        case .tap:
//            break
//        case .swipeLeft:
//            break
//        case .swipeRight:
//            break
//        case .noEvent:
//            break
//        default:
//            break
//        }
        
//        var duration: Double = 0
//        var distance: CGFloat = 0
//        var previousPoint: CGPoint?
//        var previousDuration: Double?
//        //        var swipeDirection:
//        
//        NSLog("CheckMotion")
//        
//        for p in touchPoints {
//            if previousPoint == nil {
//                previousPoint = p.point
//            } else {
//                distance += sqrt(pow((p.point.x - previousPoint!.x), 2.0) + pow((p.point.y - previousPoint!.y), 2.0))
//            }
//            if previousDuration == nil {
//                previousDuration = p.time
//            } else {
//                duration += p.time - previousDuration!
//            }
//            
//            
//        }
//        
//        let speed:Double = Double(distance) / duration
//        
//        NSLog("Speed: %f Distance %f", speed, Float(distance))


}


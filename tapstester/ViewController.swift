//
//  ViewController.swift
//  tapstester
//
//  Created by Stewart Jackson on 2014-08-18.
//  Copyright (c) 2014 Stewart Jackson. All rights reserved.
//

import UIKit

enum KeyboardTouchEventType : Printable {
    case tap(CGPoint)
    case swipeLeft
    case swipeRight
    case noEvent
    
    var description : String {
        get {
            switch self {
            case .tap(let touch):
                return "tap \(touch)"
            case .swipeLeft:
                return "swipeLeft"
            case .swipeRight:
                return "swipeRight"
            case .noEvent:
                return "noEvent"
            }
        }
    }
}

struct touchPoint {
    var point: CGPoint
    var time: Double
    
    init(touch: UITouch){
        self.point = touch.locationInView(touch.view)
        self.time = touch.timestamp
    }
}

class ViewController: UIViewController {
                            
    @IBAction func tapAction(sender: UITapGestureRecognizer) {
        NSLog("tapAction location: %@, %@", sender.locationInView(self.view).x.description, sender.locationInView(self.view).x.description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.multipleTouchEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func handleTapGesture(point: CGPoint) {
        NSLog("Do the tap thing at point %@, %@", point.x.description, point.y.description)
    }
    
    func handleSwipeLeftGesture() {
        NSLog("Do the swipe left thing <--------------")
    }
    
    func handleSwipeRightGesture() {
        NSLog("Do the swipe left thing -------------->")
    }
    
    var activeTouches: [Int: [touchPoint]] = [:]
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        NSLog("touchesBegan")
        
        for touch in touches {
            super.touchesBegan(touches, withEvent: event)
            if let touch = touch as? UITouch {
                
                NSLog("touchesBegan touch: %@", touch.description)
                activeTouches[touch.hash] = [touchPoint(touch: touch)]
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event)
        NSLog("touchesMoved %i", touches.count)
        for touch in touches {
            if let touch = touch as? UITouch {
                
                NSLog("touchesMoved touch: %@", touch.description)
                var touchPoints: [touchPoint] = activeTouches[touch.hash]!
                println("delta time: \(touch.timestamp - touchPoints[touchPoints.count-1].time)")
                touchPoints.append(touchPoint(touch: touch))
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
                var touchPoints: [touchPoint] = activeTouches[touch.hash]!
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
    
    func handleKeyboardTouchEvent(keyboardTouchEventType: KeyboardTouchEventType) {
        switch keyboardTouchEventType {
        case .tap(let point):
            handleTapGesture(point)
            break
        case .swipeLeft:
            handleSwipeLeftGesture()
            break
        case .swipeRight:
            handleSwipeRightGesture()
            break
        case .noEvent:
            break
        default:
            break
        }
    }

    func eventForTouchWithPoints(touches: [touchPoint]) -> KeyboardTouchEventType {

        return KeyboardTouchEventType.noEvent
        
        
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


}


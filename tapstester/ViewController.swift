//
//  ViewController.swift
//  tapstester
//
//  Created by Stewart Jackson on 2014-08-18.
//  Copyright (c) 2014 Stewart Jackson. All rights reserved.
//

import UIKit
import MessageUI

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
    }
    
    var description: String {
        get {
            return "\(point), delta time: \(time)"
        }
    }
}

let DEVICE_WIDTH = 320

extension TouchPoint: DebugPrintable {
// we're using the existing DebugPrintable Protocol to define our 'printable/loggable' point descriptions
    var debugDescription: String {
        get {
            return "\(DEVICE_WIDTH)\t\(point.x)\t\(point.y)\t\(time)"
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

    //MARK: event type determination
    func eventType(debug: Bool = false) -> KeyboardTouchEventType {
        if (self.count >= 2) {

            let deltaX = last.point.x - first.point.x
            let deltaY = last.point.y - first.point.y
            let deltaDistance = sqrt(deltaX * deltaX + deltaY * deltaY)
            
            let duration = last.time - first.time
            
            let xVelocity = Float(deltaX) / Float(duration)
            let yVelocity = Float(deltaY) / Float(duration)
            
            let velocity = Float(deltaDistance) / Float(duration)
            
            if debug {
                print(self)
                println("deltaX \(deltaX)\n deltaY: \(deltaY)")
                println("delta distance:", deltaDistance)
                println("duration", duration)
                println("xVelocity \(xVelocity)\n yVelocity: \(yVelocity)")
                println("total velocity:", velocity)
            }
            
            
            if _checkDiscriminant(fabs(xVelocity), displacement: Float(fabs(deltaX))) && fabs(deltaX) >= fabs(deltaY) {
//                a swipe on the x axis && x displacement > y displacement
                if deltaX < 0 {
                    return .SwipeLeft
                }else {
                    return .SwipeRight
                }
                
            }else if _checkDiscriminant(fabs(yVelocity), displacement: Float(fabs(deltaY))) && fabs(deltaX) < fabs(deltaY) {
                //                TODO: we can handle vertical swipes here?
                return .NoEvent
            }else{
                return .Tap(last.point)
            }
        }
        return .NoEvent
    }
    
    // determines if an event falls within the arbitrary bounds we use to distinguish taps from swipes:
    func _checkDiscriminant(
        speed:  Float,
        displacement: Float,
        threshHoldVelocity:     Float = 1000,
        threshholdDisplacement: Float = 50) -> Bool {
            
            let slope = (-threshHoldVelocity) / threshholdDisplacement
            if (speed > slope * displacement + threshHoldVelocity) {
                return true
            }
            return false
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
//        our touchpoints do not know their identity, so we have to add them here:
        get {
            var desc = ""
            for point in self.points {
                desc += "\(identifier)\t\(point.debugDescription)\t\(eventType())\n"
            }
            return desc
        }
    }
}

//MARK: - ViewController

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
        var activeTouches = [Int: TouchEvent]()
        var allTouchEvents = [TouchEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.multipleTouchEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    //MARK: handling recognized events
    func handleTapEvent(point: CGPoint) {
        NSLog("tap at %@, %@", point.x.description, point.y.description)
    }
    
    func handleSwipeLeftEvent() {
        NSLog("Do the swipe left thing <--------------")
    }
    
    func handleSwipeRightEvent() {
        NSLog("Do the swipe right thing -------------->")
    }
    
    //MARK: overriding UIKit touch methods
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event)
        for touch in touches {

            if let touch = touch as? UITouch {
                activeTouches[touch.hash] = TouchEvent(touch: touch)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event)
        for touch in touches {
            if let touch = touch as? UITouch {
                let touchEvent = activeTouches[touch.hash]!
                touchEvent.add(touch)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
        for touch in touches {
            if let touch = touch as? UITouch {
                let touchEvent = activeTouches[touch.hash]!
                touchEvent.add(touch)
                allTouchEvents.append(touchEvent)

                handleKeyboardTouchEvent(touchEvent.eventType())
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
    
    //MARK: handling the send action and logging
    //FIXME: FOR DEBUG PURPOSES WE ARE STORING ALL TOUCHES. IF WE ARE DONE DEBUGGING, REMOVE THE 'allTouchEvents' IVAR AND RELATED CODE.
    @IBAction func sendLogsAction(sender: UIButton) {
        var outString = ""
        for touch in allTouchEvents {
            outString += touch.debugDescription
        }
        
//        println(outString); return
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject("ios touch logs ✌️😎👆📱")
        mailComposer.setToRecipients(["colin@whirlscape.com","will@whirlscape.com"])
        //        mailComposer.setMessageBody(outString, isHTML: false)
        //       let's attach our string as a file. it's cleaner.
        
        let outData = outString.dataUsingEncoding(3, allowLossyConversion: false)
        let filename = "\(NSDateFormatter.localizedStringFromDate(NSDate.date(), dateStyle: .ShortStyle, timeStyle: .LongStyle))touches.log"
        mailComposer.addAttachmentData(outData, mimeType: "text/plain", fileName: filename)
        
        //
        
        mailComposer.mailComposeDelegate = self
        self.presentViewController(mailComposer, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}


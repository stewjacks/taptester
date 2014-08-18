//
//  ViewController.swift
//  tapstester
//
//  Created by Stewart Jackson on 2014-08-18.
//  Copyright (c) 2014 Stewart Jackson. All rights reserved.
//

import UIKit
import MessageUI

struct serializablePoint {
    var point: CGPoint
    var startTimestamp: NSTimeInterval
    var deviceWidth: Int
    var timeSinceFirstTouch: NSTimeInterval
    init(startTime: NSTimeInterval, touch: UITouch) {
        startTimestamp = startTime
        deviceWidth = Int(UIApplication.sharedApplication().keyWindow.frame.width)
        timeSinceFirstTouch = touch.timestamp - startTime
        point = touch.locationInView(touch.view)
    }
    
    
    func serialDescription() -> String {
        return "\(startTimestamp)\t\(deviceWidth)\t\(point.x)\t\(point.y)\t\(timeSinceFirstTouch)"
    }
}

struct serializableTouch {
    var points = [serializablePoint]()
    var timeStamp : NSTimeInterval
    
    init(firstTouch: UITouch) {
        timeStamp = firstTouch.timestamp
        points.append(serializablePoint(startTime: timeStamp, touch: firstTouch))
    }
    
    mutating func addPoint(touch: UITouch) {
        points.append(serializablePoint(startTime: self.timeStamp, touch: touch))
    }
    
    func count() -> Int {
        return self.points.count
    }
}

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var allTouches = [serializableTouch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.multipleTouchEnabled = true
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
    
    var activeTouches: [Int : serializableTouch] = [:]
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        NSLog("touchesBegan")
        
        for touch in touches {
            super.touchesBegan(touches, withEvent: event)
            if let touch = touch as? UITouch {
                addDecayingCircleView(touch)
                NSLog("touchesBegan touch: %@", touch.description)
//                activeTouches[touch.hash] = [VelocityObject(point: touch.locationInView(self.view), time: event.timestamp)]
                activeTouches[touch.hash] = serializableTouch(firstTouch: touch)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event)
        NSLog("touchesMoved %i", touches.count)
        for touch in touches {
            if let touch = touch as? UITouch {
                addDecayingCircleView(touch)
                NSLog("touchesMoved touch: %@", touch.description)
//                var velocityArray: [VelocityObject] = activeTouches[touch.hash]!
//                velocityArray.append(VelocityObject(point: touch.locationInView(self.view), time: event.timestamp))
                activeTouches[touch.hash]?.addPoint(touch)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("touchesEnded")
        super.touchesEnded(touches, withEvent: event)
        for touch in touches {
            if let touch = touch as? UITouch {
                addDecayingCircleView(touch)
                NSLog("touchesEnded touch: %@", touch.description)
//                var velocityArray: [VelocityObject] = activeTouches[touch.hash]!
                activeTouches[touch.hash]?.addPoint(touch)
//                NSLog("VelocityArray count %i", velocityArray.count)
                //                if velocityArray.count <= 4 {
                self.handleTap(touch as UITouch)
                
//                if !velocityArray.isEmpty && velocityArray.count > 4 {
//                    checkMotion(velocityArray)
//                }
                println("activeTouches before delete \(activeTouches.count)")
                let toSerialize = activeTouches[touch.hash]
                allTouches.append(toSerialize!)
//                dumpTouchesToFile(toSerialize!)
                
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
        
        var normalized : Double = (Double(pt.x) - Double(bounds.origin.x)) / Double(bounds.size.width)
        NSLog("Called handleTapGesture C ")
    }

    @IBAction func sendLogsAction(sender: UIButton) {
        var outString = ""
        for touch in allTouches {
            for point in touch.points {
                outString += point.serialDescription() + "\r"
                
            }
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject("ios touch logs ✌️😎👆📱")
        mailComposer.setToRecipients(["colin@whirlscape.com"])
        mailComposer.setMessageBody(outString, isHTML: false)
        mailComposer.mailComposeDelegate = self
        self.presentViewController(mailComposer, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    
//    - (IBAction)debugSendLogsAction:(UIButton *)sender {
//    
//    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
//    [mailComposer setSubject:@"DataMobile Log Data"];
//    [mailComposer setToRecipients:@[@"colin.rothfels@gmail.com"]];
//    
//    NSString* logDirectoryPath = [self logDirectoryPath];
//    NSArray *logFilePaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:logDirectoryPath error:nil];;
//    [logFilePaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//    NSString *filename = (NSString*)obj;
//    NSString *path = [logDirectoryPath stringByAppendingPathComponent:filename];
//    NSData *logData = [NSData dataWithContentsOfFile:path];
//    [mailComposer addAttachmentData:logData mimeType:@"text/plain" fileName:filename];
//    DDLogInfo(@"attached file %@, size: %@", filename, [NSByteCountFormatter stringFromByteCount:logData.length countStyle:NSByteCountFormatterCountStyleFile]);
//    }];
//    
//    mailComposer.mailComposeDelegate = self;
//    [self presentViewController:mailComposer animated:YES completion:NULL];
//    }
//    
//    -(NSString*)logDirectoryPath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
//    return logsDirectory;
//    }
//    
//    
//    -(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
//    DDLogInfo(@"mail composer finished with result: %u, error: %@", result, error.localizedDescription);
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    }

    func dumpTouchesToFile(touches: serializableTouch) {
        var outString = ""
        for point in touches.points {
            outString += point.serialDescription() + "\r"
        }
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
        let filename = "\(NSDateFormatter.localizedStringFromDate(NSDate.date(), dateStyle: .ShortStyle, timeStyle: .LongStyle))touches.log"
        
        let path = documentsDirectory.path.stringByAppendingPathComponent(filename)
        println("dumping to path \(path)")
        outString.writeToFile(path, atomically: true, encoding: 3, error: nil)
        
//        NSFileManager.defaultManager().createfil
        
        
    }
}


//- (NSURL *)applicationDocumentsDirectory {
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
//        inDomains:NSUserDomainMask] lastObject];
//}
//You can save like this:
//
//NSString *path = [[self applicationDocumentsDirectory].path
//stringByAppendingPathComponent:@"fileName.txt"];
//[sampleText writeToFile:path atomically:YES
//encoding:NSUTF8StringEncoding error:nil];
















































//
//  tapstesterTests.swift
//  tapstesterTests
//
//  Created by Stewart Jackson on 2014-08-18.
//  Copyright (c) 2014 Stewart Jackson. All rights reserved.
//

import UIKit
import XCTest

let someTestItems : [[Float]] = [
    [362971.0045248, 320, 158.0, 438.5, 0.0],
    [362971.0045248, 320, 153.5, 439.0, 0.07959066668991],
    [362971.1485901, 320, 188.0, 434.0, 0.0],
    [362971.1485901, 320, 187.0, 435.0, 0.0634840416605584],
    [362971.2925210, 320, 237.0, 433.0, 0.0],
    [362971.2925210, 320, 237.5, 432.5, 0.0635464999941178],
    [362971.4204435, 320, 104.0, 445.5, 0.0],
    [362971.4204435, 320, 103.0, 439.5, 0.0798870416474529],
    [362971.4204435, 320, 100.0, 439.5, 0.0959763749851845],
    [362971.4204435, 320, 98.0, 440.5, 0.111763624998275],
    [362971.5963865, 320, 243.5, 432.0, 0.0],
    [362971.5963865, 320, 245.0, 431.0, 0.0637995832948945],
    [362971.7564428, 320, 79.0, 432.5, 0.0],
    [362971.7564428, 320, 71.5, 435.5, 0.0957678332924843],
    [362972.1881385, 320, 81.5, 434.0, 0.0],
    [362972.1881385, 320, 71.0, 435.5, 0.0959104999783449],
    [362972.5885726, 320, 265.0, 433.5, 0.0],
    [362972.5885726, 320, 261.5, 432.5, 0.0637395833618939],
    [362972.7323937, 320, 122.0, 435.0, 0.0],
    [362972.7323937, 320, 116.5, 433.5, 0.143873458320741],
    [362972.9247047, 320, 218.0, 428.0, 0.0],
    [362972.9247047, 320, 215.0, 429.5, 0.0477152083185501],
    [362973.0682564, 320, 182.5, 438.5, 0.0],
    [362973.0682564, 320, 186.5, 435.0, 0.0480676666484214],
    [362973.2126881, 320, 276.0, 428.0, 0.0],
    [362973.2126881, 320, 277.5, 426.5, 0.0638185416464694],
    [362973.3406389, 320, 44.5, 442.5, 0.0],
    [362973.3406389, 320, 39.0, 443.0, 0.111651416635141],
    [362973.5163563, 320, 149.0, 428.0, 0.0],
    [362973.5163563, 320, 149.5, 428.5, 0.0482429583789781],
    [362973.6607378, 320, 115.5, 427.0, 0.0],
    [362973.6607378, 320, 107.0, 429.0, 0.0798735416610725],
    [362973.8367004, 320, 171.5, 424.5, 0.0],
    [362973.8367004, 320, 173.0, 423.5, 0.0318292916635983],
    [362973.9646732, 320, 194.0, 429.0, 0.0],
    [362973.9646732, 320, 192.5, 430.0, 0.0641300833085552],
    [362974.0765877, 320, 42.5, 444.0, 0.0],
    [362974.0765877, 320, 45.5, 444.0, 0.0161653750110418],
    [362974.0765877, 320, 46.5, 444.0, 0.0321413333294913],
    [362974.0765877, 320, 45.0, 443.5, 0.0964549166383222],
    [362974.0765877, 320, 45.0, 443.5, 0.112254083331209],
    [362974.1888418, 320, 159.0, 425.5, 0.0],
    [362974.1888418, 320, 159.0, 426.0, 0.0157407083315775],
    [362974.1888418, 320, 160.0, 423.0, 0.0477304583182558],
    [362974.6368988, 320, 165.0, 419.5, 0.0],
    [362974.6368988, 320, 170.0, 425.0, 0.0636464166454971],
    [362974.7649311, 320, 85.0, 429.0, 0.0],
    [362974.7649311, 320, 76.0, 432.0, 0.0955607499927282],
    [362974.9569155, 320, 81.5, 445.0, 0.0],
    [362974.9569155, 320, 152.5, 429.5, 0.0960428332909942],
    [362974.9569155, 320, 166.5, 426.5, 0.112191791646183],
    [362974.9569155, 320, 171.0, 426.0, 0.128090708283707],
    [362974.9569155, 320, 173.0, 426.0, 0.143932249979116],
    [362974.9569155, 320, 175.5, 425.5, 0.159902416635305],
    [362975.1809316, 320, 81.0, 442.0, 0.0],
    [362975.1809316, 320, 78.5, 442.0, 0.0958351250155829],
    [362975.5008958, 320, 294.0, 425.5, 0.0],
    [362975.5008958, 320, 293.5, 424.5, 0.0796110000228509],
    [362975.6608924, 320, 235.0, 418.5, 0.0],
    [362975.6608924, 320, 231.5, 416.5, 0.0637044999748468],
    [362975.8208012, 320, 175.5, 430.0, 0.0],
    [362975.8208012, 320, 170.5, 431.0, 0.111636250047013],
    [362976.0607883, 320, 61.0, 425.5, 0.0],
    [362976.0607883, 320, 59.0, 426.5, 0.0802164583583362],
    [362976.0607883, 320, 59.0, 426.5, 0.0960571250179783],
    [362976.1568455, 320, 210.5, 436.0, 0.0],
    [362976.1568455, 320, 210.0, 436.5, 0.0475464166374877],
    [362976.3006732, 320, 91.5, 435.5, 0.0],
    [362976.3006732, 320, 91.5, 435.5, 0.112048999988474],
    [362976.4127222, 320, 179.0, 422.5, 0.0],
    [362976.4127222, 320, 171.5, 429.5, 0.0478054583072662],
    [362976.6046473, 320, 210.0, 436.5, 0.0],
    [362976.6046473, 320, 210.5, 438.0, 0.0797912916750647],
    [362976.8606352, 320, 116.0, 431.5, 0.0],
    [362976.8606352, 320, 107.0, 434.5, 0.0955452916678041],
    [362977.0364653, 320, 89.5, 428.0, 0.0],
    [362977.0364653, 320, 86.0, 429.0, 0.0796430833288468],
    [362977.1964140, 320, 123.0, 438.0, 0.0],
    [362977.1964140, 320, 115.5, 436.0, 0.0317385416710749],
    [362977.8362707, 320, 169.5, 428.0, 0.0],
    [362977.8362707, 320, 170.5, 431.0, 0.0478312916820869],
    [362977.9802438, 320, 199.0, 427.0, 0.0],
    [362977.9802438, 320, 197.0, 428.5, 0.0638190416502766],
    [362978.1403305, 320, 34.5, 428.0, 0.0],
    [362978.1403305, 320, 32.0, 428.5, 0.0955572916427627],
    [362978.2841922, 320, 275.5, 441.5, 0.0],
    [362978.2841922, 320, 268.0, 449.0, 0.0639126250171103],
    [362978.9561219, 320, 172.5, 437.5, 0.0],
    [362978.9561219, 320, 172.5, 436.0, 0.0477894999785349],
    [362979.1161100, 320, 192.5, 447.5, 0.0],
    [362979.1161100, 320, 192.5, 446.0, 0.0159028333146125],
    [362979.7401046, 320, 296.0, 449.5, 0.0],
    [362979.7401046, 320, 292.0, 447.5, 0.0478396666585468],
    [362979.8840615, 320, 287.0, 445.0, 0.0],
    [362979.8840615, 320, 289.0, 444.0, 0.0637589999823831],
    [362980.0280168, 320, 300.5, 443.0, 0.0],
    [362980.0280168, 320, 300.5, 443.0, 0.063620750035625],
    [362980.3959819, 320, 288.0, 433.0, 0.0],
    [362980.3959819, 320, 288.0, 433.5, 0.0635190833127126],
    [362980.5877316, 320, 301.5, 425.0, 0.0],
    [362980.5877316, 320, 300.0, 427.5, 0.0476017083274201]]


extension TouchPoint {
    init(array: [Float]) {
        self.point = CGPointMake(CGFloat(array[2]), CGFloat(array[3]))
        self.time = Double(array[4])
    }
}

extension TouchEvent {
    convenience init(pointArray: [Float]) {
        let point = TouchPoint(array: pointArray)
        let ident = Int(pointArray[0] * 100) // gotta keep that double percis
        self.init(point: point, identifier: ident)
    }
    
    func add(pointArray: [Float]) {
        points.append(TouchPoint(array: pointArray))
    }
}

class tapstesterTests: XCTestCase {
    var testItems = [TouchEvent]()
//    var testArray = [[TouchPoint]]()
//
    override func setUp() {
        super.setUp()

       
        var testDict = Dictionary<Float, TouchEvent>()
        
        for item in someTestItems {
            let touchPoint = TouchPoint(array: item)
            let key = item[0]
            let event = testDict[key]
            if event != nil {
                event!.add(item)
            }else{
                testDict[key] = TouchEvent(pointArray: item)
            }
        }
    
    for testPoints in testDict.values {
        testItems.append(testPoints)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatOurDataExists() {
        // This is an example of a functional test case.
        println("dataloaded: \(self.testItems.count)")
        
//        for item in self.testItems {
//            println(item)
//        }
        
        XCTAssert(self.testItems.count == 45, "failed to load test items")
    }

    func testTapDetection() {
        let vc = ViewController()
        for testItem in self.testItems {
            let eventType = testItem.eventType(debug: true)
            println(eventType, "\n")
            
        }
//        println(results)
    
}
    
    
    func testEventSequence() {
        println("testing event sequence")
        for testItem in self.testItems {
            let targetCount = testItem.count
            var ourCount = 0
            for touch in testItem {
                println(touch)
                ourCount += 1
            }
            XCTAssertEqual(targetCount, ourCount, "sequence returned incomplete record")
        }
    }
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}

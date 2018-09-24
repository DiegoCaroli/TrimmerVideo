//
//  TrimmerViewTests.swift
//  TrimmerVideoTests
//
//  Created by Diego Caroli on 24/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import XCTest
import AVFoundation
@testable import TrimmerVideo

class TrimmerViewTests: XCTestCase {

    var trimmerView: TrimmerView!
    var bundle: Bundle!
    var fileURL: URL!
    var asset: AVAsset!
    
    override func setUp() {
        super.setUp()
        
        trimmerView = TrimmerView()
        bundle = Bundle(for: type(of: self))
        fileURL = bundle.url(forResource: "IMG_0065", withExtension: "m4v")
        asset = AVAsset(url: fileURL)
        
        trimmerView.frame = CGRect(x: 0, y: 0, width: 140, height: 50)
        trimmerView.assetThumbnailsView = AssetThumbnailsView(
            frame: CGRect(x: 20, y: 0, width: 100, height: 50))
        trimmerView.rightDraggableView = UIView(frame: CGRect(x: 120,
                                                              y: 0,
                                                              width: 20,
                                                              height: 50))
        trimmerView.assetThumbnailsView.asset = asset
        
        _ = trimmerView.awakeFromNib()
    }
    
    override func tearDown() {
        trimmerView = nil
        bundle = nil
        fileURL = nil
        asset = nil
        
        super.tearDown()
    }
    
    func testBorderColor() {
        trimmerView.mainColor = UIColor.blue
        
        XCTAssertEqual(trimmerView.trimView.layer.borderColor,
                       trimmerView.mainColor.cgColor)
    }
    
    func testLeftViewBackgroundColor() {
        trimmerView.mainColor = UIColor.blue
        
        XCTAssertEqual(trimmerView.leftDraggableView.backgroundColor,
                       trimmerView.mainColor)
    }
    
    func testRightViewBackgroundColor() {
        trimmerView.mainColor = UIColor.blue
        
        XCTAssertEqual(trimmerView.rightDraggableView.backgroundColor,
                       trimmerView.mainColor)
    }
    
    func testTrimViewWidth() {
        trimmerView.borderWidth = 4
        
        XCTAssertEqual(trimmerView.trimView.layer.borderWidth,
                       trimmerView.borderWidth)
    }
    
    private func testAlphaLeftMaskView() {
        trimmerView.alphaView = 0.5
        
        XCTAssertEqual(trimmerView.leftMaskView.alpha,
                       trimmerView.alphaView)
    }
    
    private func testAlphaRightMaskView() {
        trimmerView.alphaView = 0.5
        
        XCTAssertEqual(trimmerView.rightMaskView.alpha,
                       trimmerView.alphaView)
    }
    
//    func testLeftViewWidth() {
//        trimmerView.draggableViewWidth = 4
//
//        XCTAssertEqual(trimmerView.leftDraggableView.bounds.width,
//                       trimmerView.draggableViewWidth)
//    }
//
//    func testRightViewWidth() {
//       trimmerView.borderWidth = 4
//
//        XCTAssertEqual(trimmerView.rightDraggableView.backgroundColor,
//                       trimmerView.mainColor)
//    }
    
    func testStarTimeWithFullVideo() {
        XCTAssertEqual(trimmerView.startTime,
                       CMTime(value: CMTimeValue(0), timescale: 600))
    }
    
    func testEndTimeWithFullVideo() {
        let value = Int(asset.duration.seconds * Double(asset.duration.timescale))
        XCTAssertEqual(trimmerView.endTime,
                       CMTime(value: CMTimeValue(value), timescale: 600))
    }


}

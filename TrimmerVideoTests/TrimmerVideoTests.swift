//
//  TrimmerVideoTests.swift
//  TrimmerVideoTests
//
//  Created by Diego Caroli on 24/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import XCTest
import AVFoundation
@testable import TrimmerVideo

class TrimmerVideoTests: XCTestCase {
    
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
    
    func testLoadAssetReturnNotNil() {
        XCTAssertNotNil(trimmerView.assetThumbnailsView.asset)
    }
    
    func testGenerateImageCountThumbnails() {
        XCTAssertEqual(trimmerView.assetThumbnailsView.imageViewsCount,
                       4)
        
    }
    
    func testGetDurationSize() {
        XCTAssertEqual(trimmerView.assetThumbnailsView.durationSize,
                       100)
    }
    
    func testGetTimeWithMinTime() {
        XCTAssertEqual(trimmerView.assetThumbnailsView.getTime(from: 0),
                       CMTime(value: CMTimeValue(0), timescale: 600))
    }
    
    func testGetTimeWithMaXTime() {
        let value = Int(asset.duration.seconds * Double(asset.duration.timescale))
        XCTAssertEqual(trimmerView.assetThumbnailsView
            .getTime(from: trimmerView.assetThumbnailsView.bounds.width),
                       CMTime(value: CMTimeValue(value),
                              timescale: 600))
    }
    
    func testGetPostionWithMinTime() {
        XCTAssertEqual(trimmerView.assetThumbnailsView
            .getPosition(from: CMTime(value: CMTimeValue(0), timescale: 600)),
                       0)
        
    }
    
    func testGetPostionWithMaxTime() {
        let value = Int(asset.duration.seconds * Double(asset.duration.timescale))
        XCTAssertEqual(trimmerView.assetThumbnailsView
            .getPosition(from: CMTime(value: CMTimeValue(value), timescale: 600)),
                       trimmerView.assetThumbnailsView.bounds.maxX)
        
    }
    
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


class MockPanGesture: UIPanGestureRecognizer {
    
}

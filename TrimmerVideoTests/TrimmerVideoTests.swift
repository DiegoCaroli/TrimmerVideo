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
    
    var trimmerVideo: TrimmerView!
    var bundle: Bundle!
    var fileURL: URL!
    var asset: AVAsset!
    
    override func setUp() {
        super.setUp()
        
        trimmerVideo = TrimmerView()
        bundle = Bundle(for: type(of: self))
        fileURL = bundle.url(forResource: "IMG_0065", withExtension: "m4v")
        asset = AVAsset(url: fileURL)
        
        trimmerVideo.assetThumbnailsView = AssetThumbnailsView(
            frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        trimmerVideo.assetThumbnailsView.asset = asset
    }
    
    override func tearDown() {
        trimmerVideo = nil
        bundle = nil
        fileURL = nil
        asset = nil
        
        
        super.tearDown()
    }
    
    func testLoadAssetReturnNotNil() {
        XCTAssertNotNil(trimmerVideo.assetThumbnailsView.asset)
    }
    
    func testGenerateImageCountThumbnails() {
        XCTAssertEqual(trimmerVideo.assetThumbnailsView.imageViewsCount,
                       4)
        
    }
    
    func testGetDurationSize() {
        XCTAssertEqual(trimmerVideo.assetThumbnailsView.durationSize,
                       100)
    }
    
    func testGetTimeWithMinTime() {
        XCTAssertEqual(trimmerVideo.assetThumbnailsView.getTime(from: 0),
                       CMTime(value: CMTimeValue(0), timescale: 600))
    }
    
    func testGetTimeWithMaXTime() {
        let value = Int(asset.duration.seconds * Double(asset.duration.timescale))
        XCTAssertEqual(trimmerVideo.assetThumbnailsView
            .getTime(from: trimmerVideo.assetThumbnailsView.bounds.width),
                       CMTime(value: CMTimeValue(value),
                              timescale: 600))
    }
    
    func testGetPostionWithMinTime() {
        XCTAssertEqual(trimmerVideo.assetThumbnailsView
            .getPosition(from: CMTime(value: CMTimeValue(0), timescale: 600)),
                       0)
        
    }
    
    func testGetPostionWithMaxTime() {
        let value = Int(asset.duration.seconds * Double(asset.duration.timescale))
        XCTAssertEqual(trimmerVideo.assetThumbnailsView
            .getPosition(from: CMTime(value: CMTimeValue(value), timescale: 600)),
                       trimmerVideo.assetThumbnailsView.frame.maxX)
        
    }
    
    func testA() {
        
    }
    
}

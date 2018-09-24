//
//  TrimmingControllerTests.swift
//  TrimmerVideoTests
//
//  Created by Diego Caroli on 24/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import XCTest
@testable import TrimmerVideo

class TrimmingControllerTests: XCTestCase {
    
    var trimmingController: TrimmingController!
    var trimmerView: TrimmerView!

    override func setUp() {
        super.setUp()
        
        trimmingController = TrimmingController()
        let trimmerView = TrimmerView()
        trimmingController.trimmerView = trimmerView
    }

    override func tearDown() {
        trimmingController = nil
        trimmerView = nil
        
        super.tearDown()
    }
    
    func testDelegateNotNil() {
        XCTAssertNotNil(trimmingController.trimmerView.delegate)
    }

}

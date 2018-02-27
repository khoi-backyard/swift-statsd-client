//
//  FloatExtensionsTests.swift
//  StatsDClient
//
//  Created by Khoi Lai on 2/27/18.
//  Copyright © 2018 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsDClient

class FloatExtensionsTests: XCTestCase {

    func testClean() {
        let a: Float = 0.30
        let b: Float = 0.31
        XCTAssertEqual(a.clean, "0.3")
        XCTAssertEqual(b.clean, "0.31")
        
        
    }

}

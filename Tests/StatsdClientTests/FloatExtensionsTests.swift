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
        XCTAssertEqual(Float(0.30).clean, "0.3")
        XCTAssertEqual(Float(0.300).clean, "0.3")
        XCTAssertEqual(Float(0.3000).clean, "0.3")
        XCTAssertEqual(Float(0.30001).clean, "0.30001")

        XCTAssertEqual(Float(0.31).clean, "0.31")
        XCTAssertEqual(Float(0.310).clean, "0.31")
        XCTAssertEqual(Float(0.3101).clean, "0.3101")
    }

}

//
//  StatsdClientTests.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class StatsdClientTests: XCTestCase {

    func testExample() {
        let statsD = StatsD(transport: TCPTransport(host: "ASD", port: 80))
        statsD.write(metric: Counting(name: "counting", value: 1))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

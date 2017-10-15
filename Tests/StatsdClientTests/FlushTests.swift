//
//  FlushTests.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class FlushTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFlushCallStartOnAllScheme() {
        let schemes = [SpyScheme(),
                       SpyScheme(),
                       SpyScheme(),
                       ]
        let flush = Flush(schemes: schemes)

        flush.start()

        schemes.forEach { (scheme) in
            XCTAssertTrue(scheme.isStartCall, "Flush should call start() in each Schemes")
        }
    }

    func testFlushCallDelegateWhenSchemeNeedFlush() {
        let scheme = SpyScheme()
        let statsD = SpyFlushDelegate()
        let flush = Flush(schemes: [scheme])
        flush.delegate = statsD

        flush.start()
        scheme.excess()

        XCTAssertTrue(statsD.isCallFlush, "When scheme excesses threshold, it should call flush() on StatsD")
    }
}

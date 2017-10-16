//
//  IntervalFlushSchemeTests.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class IntervalFlushSchemeTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSchemeShouldCallFlushOnDelegate() {
        let delegate = SpyFlushSchemeDelegate()
        let intervalScheme = IntervalFlushScheme(interval: 1)

        intervalScheme.start(delegate: delegate)
        wait(for: 1.5)

        XCTAssertTrue(delegate.isCallFlushed, "IntervalScheme should call delegate's flush when it's excessed")
    }
}

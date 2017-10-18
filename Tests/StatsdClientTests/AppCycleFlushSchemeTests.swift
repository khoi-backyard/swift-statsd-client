//
//  AppCycleFlushScheme.swift
//  StatsdClient-iOS Tests
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

class AppCycleFlushSchemeTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSchemeShouldCallFlushOnDelegate() {
        let delegate = SpyFlushSchemeDelegate()
        let appCycleScheme = AppCycleFlushScheme()

        appCycleScheme.start(delegate: delegate)
        #if os(macOS)
            NotificationCenter.default.post(name: NSApplication.willResignActiveNotification,
                                            object: nil,
                                            userInfo: nil)
        #else
            NotificationCenter.default.post(name: .UIApplicationDidEnterBackground,
                                            object: nil,
                                            userInfo: nil)
        #endif

        XCTAssertTrue(delegate.isCallFlushed, "AppCycle should call delegate's flush when it's excessed")
    }
}

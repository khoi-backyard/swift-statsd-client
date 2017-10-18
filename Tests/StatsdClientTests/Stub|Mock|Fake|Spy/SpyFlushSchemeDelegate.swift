//
//  SpyFlush.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
@testable import StatsdClient

class SpyFlushSchemeDelegate: FlushSchemeDelegate {

    var isCallFlushed = false

    func flush(scheme: FlushScheme) {
        isCallFlushed = true
    }
}

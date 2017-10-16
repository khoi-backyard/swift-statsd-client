//
//  SpyStatsD.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
@testable import StatsdClient

class SpyFlushDelegate: FlushDelegate {

    var isCallFlushed = false

    func flush(_ sender: Flushable) {
        isCallFlushed = true
    }
}

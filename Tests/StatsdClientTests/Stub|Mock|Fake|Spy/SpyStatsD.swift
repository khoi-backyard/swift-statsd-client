//
//  SpyStatsD.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
@testable import StatsdClient

class SpyStatsD: FlushDelegate {

    var isCallFlush = false

    func flush(_ sender: Flushable) {
        isCallFlush = true
    }
}

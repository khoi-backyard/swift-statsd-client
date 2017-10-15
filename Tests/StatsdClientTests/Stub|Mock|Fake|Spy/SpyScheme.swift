//
//  SpyScheme.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
@testable import StatsdClient

class SpyScheme: FlushScheme {

    var isStartCall = false
    weak var delegate: FlushSchemeDelegate?

    func start(delegate: FlushSchemeDelegate) {
        self.delegate = delegate
        isStartCall = true
    }

    func stop() {

    }

    func excess() {
        delegate?.flush(scheme: self)
    }
}

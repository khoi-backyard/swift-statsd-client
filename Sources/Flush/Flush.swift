//
//  Flush.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

final class Flush: Flushable {

    var schemes: [FlushScheme]
    weak var delegate: FlushDelegate?

    init(schemes: [FlushScheme]) {
        self.schemes = schemes
    }

    func start() {
        self.schemes.forEach { (scheme) in
            scheme.start(delegate: self)
        }
    }
}

extension Flush: FlushSchemeDelegate {

    func flush(scheme: FlushScheme) {
        delegate?.flush(self)
    }
}

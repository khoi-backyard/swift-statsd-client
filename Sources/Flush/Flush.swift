//
//  Flush.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol FlushDelegate: class {

    func flush(_ sender: Flushable)
}

final class Flush: Flushable {

    let schemes: [FlushScheme]
    weak var delegate: FlushDelegate?

    init(schemes: [FlushScheme]) {
        self.schemes = schemes
    }

    func start() {
        schemes.forEach { (scheme) in
            scheme.start(delegate: self)
        }
    }
}

extension Flush: FlushSchemeDelegate {

    func flush(scheme: FlushScheme) {
        delegate?.flush(self)
    }
}

//
//  AppCycleFlushScheme.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

final class AppCycleFlushScheme: FlushScheme {

    private weak var delegate: FlushSchemeDelegate?

    private func register() {

    }

    private func unRegister() {

    }

    private func didEnterBackground() {
        delegate?.flush(scheme: self)
    }

    func start(delegate: FlushSchemeDelegate) {
        self.delegate = delegate
        register()
    }
}

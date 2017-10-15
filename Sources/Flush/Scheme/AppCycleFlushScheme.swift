//
//  AppCycleFlushScheme.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

final class AppCycleFlushScheme: FlushScheme {

    private weak var delegate: FlushSchemeDelegate?

    deinit {
        stop()
    }

    func start(delegate: FlushSchemeDelegate) {
        self.delegate = delegate
        observeAppCycle()
    }

    func stop() {
        unObserveAppCycle()
    }
}

extension AppCycleFlushScheme {

    #if os(macOS)
    private func observeAppCycle() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.flush),
                                               name: NSApplication.willResignActiveNotification,
                                               object: nil)
    }

    #else
    private func observeAppCycle() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.flush),
                                               name: .UIApplicationDidEnterBackground,
                                               object: nil)
    }
    #endif

    private func unObserveAppCycle() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func flush() {
        delegate?.flush(scheme: self)
    }
}

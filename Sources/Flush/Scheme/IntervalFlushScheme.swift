//
//  IntervalFlushScheme.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

final class IntervalFlushScheme: FlushScheme {

    private let interval: TimeInterval
    private var timer: Timer?
    private weak var delegate: FlushSchemeDelegate?

    init(interval: TimeInterval) {
        self.interval = interval
    }

    private func invalidTimer() {
        guard let timer = timer else {
            return
        }

        timer.invalidate()
        self.timer = nil
    }

    private func createTimer() {
        guard timer == nil else {
            return
        }

        timer = Timer(timeInterval: interval,
                      target: self,
                      selector: #selector(self.timerFired),
                      userInfo: nil,
                      repeats: true)
    }

    @objc func timerFired() {
        delegate?.flush(scheme: self)
    }

    func start(delegate: FlushSchemeDelegate) {
        self.delegate = delegate
        createTimer()
    }
}

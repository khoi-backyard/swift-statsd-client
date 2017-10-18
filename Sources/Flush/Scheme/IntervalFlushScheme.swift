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
    fileprivate let queue = DispatchQueue(label: "StatsD_IntervalFlushScheme",
                                          qos: .background,
                                          attributes: .concurrent)

    init(interval: TimeInterval = 100) {
        self.interval = interval
    }

    deinit {
        stop()
    }

    func start(delegate: FlushSchemeDelegate) {
        self.delegate = delegate
        scheduleTimer()
    }

    func stop() {
        invalidTimer()
    }
}

extension IntervalFlushScheme {

    fileprivate func invalidTimer() {
        queue.sync { [unowned self] in
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    fileprivate func scheduleTimer() {
        guard timer == nil else {
            return
        }

        queue.async { [unowned self] in
            let timer = Timer(timeInterval: self.interval,
                              target: self,
                              selector: #selector(self.timerFired),
                              userInfo: nil,
                              repeats: true)
            self.timer = timer
            let loop = RunLoop.current
            loop.add(timer, forMode: .commonModes)
            loop.run()
        }

    }

    @objc func timerFired() {
        delegate?.flush(scheme: self)
    }
}

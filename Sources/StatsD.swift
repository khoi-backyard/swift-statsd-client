//
//  Stats.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol StatsdProtocol {

    var transport: Transport { get }

    func increment(_ bucket: String, by value: Int)
    func set(_ bucket: String, value: String)
    func timing(_ bucket: String, value: Int)
    func gauge(_ bucket: String, value: UInt)
    func gauge(_ bucket: String, delta: Int)
}

public class StatsD: NSObject, StatsdProtocol {

    let transport: Transport
    private let storage: MemoryStorage<Metric>
    private var flush: Flushable

    public convenience init(transport: Transport) {
        let storage = MemoryStorage<Metric>()
        let schemes: [FlushScheme] = [AppCycleFlushScheme(),
                                      IntervalFlushScheme(),
                                      ]
        let flush = Flush(schemes: schemes)
        self.init(transport: transport, storage: storage, flush: flush)
    }

    init(transport: Transport, storage: MemoryStorage<Metric>, flush: Flushable) {
        self.transport = transport
        self.flush = flush
        self.storage = storage
        super.init()

        self.flush.delegate = self
        flush.start()
    }

    public func increment(_ bucket: String, by value: Int = 1) {
        let metric = Counting(name: bucket, value: "\(value)")
        storage.set(item: metric, forKey: metric.id)
    }

    public func set(_ bucket: String, value: String) {
        let metric = Sets(name: bucket, value: value)
        storage.set(item: metric, forKey: metric.id)
    }

    public func timing(_ bucket: String, value: Int) {
        let metric = Timing(name: bucket, value: value)
        storage.set(item: metric, forKey: metric.id)
    }

    public func gauge(_ bucket: String, value: UInt) {
        let metric = Gauge(name: bucket, value: value)
        storage.set(item: metric, forKey: metric.id)
    }

    public func gauge(_ bucket: String, delta: Int) {
        let metric = Gauge(name: bucket, delta: delta)
        storage.set(item: metric, forKey: metric.id)
    }
}

extension StatsD: FlushDelegate {

    func flush(_ sender: Flushable) {
        guard !storage.isEmpty else {
            return
        }

        let batch = StatsD.accumulate(metrics: storage.getAllItems())

        transport.write(data: batch) { [unowned self] (error) in
            guard error == nil else {
                return
            }
            self.storage.removeAll()
        }
    }

    private static func accumulate(metrics: [Metric]) -> String {
        return metrics.map { $0.metricData }
            .joined(separator: "\n")
    }
}

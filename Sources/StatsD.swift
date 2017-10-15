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
    private let schemes: [FlushScheme]
    private var flush: Flushable

    public convenience init(transport: Transport) {
        let storage = MemoryStorage<Metric>()
        let schemes: [FlushScheme] = [AppCycleFlushScheme(),
                                      IntervalFlushScheme(),
                                      ]
        let flush = Flush(schemes: schemes)
        self.init(transport: transport, storage: storage, schemes: schemes, flush: flush)
    }

    init(transport: Transport, storage: MemoryStorage<Metric>, schemes: [FlushScheme], flush: Flushable) {
        self.transport = transport
        self.flush = flush
        self.storage = storage
        self.schemes = schemes
        super.init()

        self.flush.delegate = self
        flush.start()
    }

    public func increment(_ bucket: String, by value: Int = 1) {
        storage.set(item: Counting(name: bucket, value: "\(value)"), forKey: bucket)
    }

    public func set(_ bucket: String, value: String) {
        storage.set(item: Sets(name: bucket, value: value), forKey: bucket)
    }

    public func timing(_ bucket: String, value: Int) {
        storage.set(item: Timing(name: bucket, value: value), forKey: bucket)
    }

    public func gauge(_ bucket: String, value: UInt) {
        storage.set(item: Gauge(name: bucket, value: value), forKey: bucket)
    }

    public func gauge(_ bucket: String, delta: Int) {
        storage.set(item: Gauge(name: bucket, delta: delta), forKey: bucket)
    }
}

extension StatsD: FlushDelegate {

    func flush(_ sender: Flushable) {
        let batch = mapToBatch()
        transport.write(data: batch, completion: nil)
        transport.write(data: batch) {[unowned self] (error) in
            guard error == nil else {
                return
            }
            self.storage.removeAll()
        }
    }

    private func mapToBatch() -> String {
        return storage.getAllItems().reduce("") { $0 + "\n" + $1.metricData }
    }
}

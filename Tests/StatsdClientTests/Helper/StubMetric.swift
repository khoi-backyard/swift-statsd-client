//
//  StubMetric.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
@testable import StatsdClient

struct StubMetric: Metric, Codable {

    fileprivate var _name: String
    var name: String { return _name }

    var value: String { return "100" }

    var metricData: String { return "\(name):\(value)" }

    var sample: Float? { return 0 }

    init(name: String = "StubMetric") {
        _name = name
    }
}

extension StubMetric: EncodeSerializable {
    func encode() -> Data {
        return try! JSONEncoder().encode(self)
    }
}

extension StubMetric: DecodeSerialable {
    init(data: Data) {
        self = try! JSONDecoder().decode(StubMetric.self, from: data)
    }
}

extension StubMetric: Equatable {
    public static func ==(lhs: StubMetric, rhs: StubMetric) -> Bool {
        guard lhs.name == rhs.name else { return false }
        guard lhs.value == rhs.value else { return false }
        guard lhs.metricData == rhs.metricData else { return false }
        guard lhs.sample == rhs.sample else { return false }
        return true
    }
}

//
//  ThresholdScheme.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

struct ThresholdFlushScheme: FlushScheme {

    private let threshold: Int

    init(threshold: Int) {
        self.threshold = threshold
    }

    func start(delegate: FlushSchemeDelegate) {

    }
}

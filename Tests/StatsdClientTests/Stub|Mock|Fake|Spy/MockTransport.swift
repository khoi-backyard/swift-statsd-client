//
//  MockTransport.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
@testable import StatsdClient

class MockTransport: Transport {

    var isCallWritten = false
    var writeData = ""
    var fakeError: Error?

    func write(data: String, completion: TransportCompletionCallback?) {
        writeData = data
        isCallWritten = true
        completion?(fakeError)
    }
}

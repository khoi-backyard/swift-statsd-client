//
//  Client.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/11/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public typealias TransportCompletionCallback = (Error?) -> Void

enum TransportError: Error {
    case invalidData
}

public protocol Transport {
    func write(data: String, completion: TransportCompletionCallback?)
}

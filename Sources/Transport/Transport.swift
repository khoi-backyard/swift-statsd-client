//
//  Client.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/11/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

typealias TransportCompletionCallback = (Error?) -> Void

enum TransportError: Error {
    case invalidData
    case timeout
}

protocol Transport {
    func write(data: String, completion: TransportCompletionCallback?)
}

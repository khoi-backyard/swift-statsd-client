//
//  TCPTransport.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/11/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class TCPTransport: NSObject, Transport {
    let host: String
    let port: UInt16

    private var completionBlocks = [Int: TransportCompletionCallback]()
    private let completionLock = NSLock()
    private var tag: Int = 0
    private var timeOut: TimeInterval

    /// Access the completion block in a thread-safe manner.
    subscript(tag: Int) -> TransportCompletionCallback? {
        get {
            completionLock.lock()
            defer { completionLock.unlock() }
            return completionBlocks[tag]
        }
        set {
            completionLock.lock()
            defer { completionLock.unlock() }
            completionBlocks[tag] = newValue
        }
    }

    private lazy var socket: GCDAsyncSocket = {
        GCDAsyncSocket(delegate: self,
                       delegateQueue: DispatchQueue(label: "TCPClient_Delegate_Queue"))
    }()

    public init(host: String, port: UInt16, timeOut: TimeInterval = 15) {
        self.host = host
        self.port = port
        self.timeOut = timeOut
        super.init()
    }

    public func write(data: String, completion: TransportCompletionCallback?) {
        guard let data = data.data(using: String.Encoding.utf8) else {
            completion?(TransportError.invalidData)
            return
        }

        if tag == Int.max {
            tag = 0
        }
        tag += 1

        self[tag] = completion

        socket.write(data, withTimeout: timeOut, tag: tag)
    }
}

extension TCPTransport: GCDAsyncSocketDelegate {
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        guard self[tag] != nil else {
            return
        }
        self[tag]?(nil)
        self[tag] = nil
    }

    public func socket(_ sock: GCDAsyncSocket,
                       shouldTimeoutWriteWithTag tag: Int,
                       elapsed: TimeInterval,
                       bytesDone length: UInt) -> TimeInterval {
        self[tag]?(TransportError.timeout)
        self[tag] = nil
        return -1
    }
}

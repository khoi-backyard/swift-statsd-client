//
//  UDPClient.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/10/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//
import Foundation
import CocoaAsyncSocket

public class UDPTransport: NSObject, Transport {
    let host: String
    let port: UInt16

    private lazy var socket: GCDAsyncUdpSocket = {
        GCDAsyncUdpSocket(delegate: self,
                          delegateQueue: DispatchQueue(label: "UDPClient_Delegate_Queue"))
    }()
    private var completionBlocks = [Int: TransportCompletionCallback]()
    private let completionLock = NSLock()
    private var tag: Int = 0

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

    public init(host: String, port: UInt16) {
        self.host = host
        self.port = port
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

        socket.send(data,
                    toHost: host,
                    port: port,
                    withTimeout: -1,
                    tag: tag)
    }
}

extension UDPTransport: GCDAsyncUdpSocketDelegate {
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        guard self[tag] != nil else {
            return
        }
        self[tag]?(nil)
        self[tag] = nil
    }

    public func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        guard self[tag] != nil else {
            return
        }

        self[tag]?(error)
        self[tag] = nil
    }
}

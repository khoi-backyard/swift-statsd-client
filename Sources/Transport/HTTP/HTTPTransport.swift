//
//  HTTPTransport.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/24/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public class HTTPTransport: NSObject, Transport {
    let endpoint: URL
    let httpMethod: String

    lazy var urlSession: URLSessionDataProtocol = {
        let session = URLSession(configuration: configuration,
                                 delegate: self,
                                 delegateQueue: nil)
        return session
    }()

    private var completionBlocks = [Int: TransportCompletionCallback]()
    private var completionLock = NSLock()

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

    private let configuration: URLSessionConfiguration

    public init(endpoint: URL,
                httpMethod: String = "POST",
                configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.endpoint = endpoint
        self.configuration = configuration
        self.httpMethod = httpMethod
    }

    public func write(data: String, completion: TransportCompletionCallback?) {
        guard let data = data.data(using: String.Encoding.utf8) else {
            completion?(TransportError.invalidData)
            return
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = httpMethod
        request.httpBody = data

        let task = urlSession.dataTask(with: request)

        self[task.taskIdentifier] = completion
        task.resume()
    }
}

extension HTTPTransport: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard self[task.taskIdentifier] != nil else {
            return
        }
        self[task.taskIdentifier]?(error)
        self[task.taskIdentifier] = nil
    }
}

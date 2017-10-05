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

    lazy var urlSession: URLSessionDataProtocol = {
        let session = URLSession(configuration: configuration,
                                 delegate: self,
                                 delegateQueue: nil)
        return session
    }()

    private var completionBlocks = [Int: TransportCompletionCallback]()
    private let configuration: URLSessionConfiguration

    public init(endpoint: URL, configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.endpoint = endpoint
        self.configuration = configuration
    }

    public func write(data: String, completion: TransportCompletionCallback?) {
        guard let data = data.data(using: String.Encoding.utf8) else {
            completion?(TransportError.invalidData)
            return
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = data

        let task = urlSession.dataTask(with: request)

        completionBlocks[task.taskIdentifier] = completion
        task.resume()
    }
}

extension HTTPTransport: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let callback = completionBlocks[task.taskIdentifier] else {
            return
        }
        callback(error)
        completionBlocks[task.taskIdentifier] = nil
    }
}


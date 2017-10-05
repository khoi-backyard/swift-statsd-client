//
//  URLSessionProtocol.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/24/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public protocol URLSessionDataProtocol {
    var delegate: URLSessionDelegate? { get }

    func dataTask(with request: URLRequest) -> URLSessionDataTask

    func getDataTasks(completion: @escaping ([URLSessionDataTask]) -> Void)
}

extension URLSession: URLSessionDataProtocol {
    public func getDataTasks(completion: @escaping ([URLSessionDataTask]) -> Void) {
        getTasksWithCompletionHandler { (datas, _, _) in
            completion(datas)
        }
    }
}


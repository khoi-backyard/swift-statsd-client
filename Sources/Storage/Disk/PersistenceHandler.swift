//
//  PersistanceHandler.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol PersistenceHandler {

    func makeFilePath(_ key: String) -> String
    func write(_ data: Data, path: String)
    func get<T: Serializable>(path: String) -> T
}

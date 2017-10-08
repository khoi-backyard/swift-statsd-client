//
//  DataSerializable.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

typealias Serializable = EncodeSerializable & DecodeSerialable

protocol EncodeSerializable {

    func encode() -> Data
}

protocol DecodeSerialable {

    init(data: Data)
}

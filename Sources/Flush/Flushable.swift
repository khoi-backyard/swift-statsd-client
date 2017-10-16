//
//  Flushable.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol Flushable {

    weak var delegate: FlushDelegate? { get set }

    var schemes: [FlushScheme] { get }

    func start()
}

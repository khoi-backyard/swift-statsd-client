//
//  FlushScheme.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol FlushScheme {

    func start(delegate: FlushSchemeDelegate)
    func stop()
}

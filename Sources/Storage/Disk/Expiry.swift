//
//  Expiry.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

enum Expiry {

    // Never
    case never

    // After specific seconds
    case second(TimeInterval)

    // After Specific Date
    case day(Date)
}

//
//  DispatchQueue+Polyfills.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

extension DispatchQueue {
    func syncWithReturnedValue<T>(execute work: () throws -> T) rethrows -> T {
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, *) {
            return try sync {
                try work()
            }
        }
        var returnedValue: T!
        try sync {
            returnedValue = try work()
        }
        return returnedValue
    }
}

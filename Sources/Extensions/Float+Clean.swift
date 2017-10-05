//
//  Float+Clean.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

extension Float {
    var clean: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

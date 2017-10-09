//
//  String+FileURL.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

extension String {

    func fileURL() -> URL {
        return URL(fileURLWithPath: self)
    }
}

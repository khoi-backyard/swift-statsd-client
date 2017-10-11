//
//  Base64Transformable.swift
//  StatsdClient-iOS
//
//  Created by Nghia Tran on 10/11/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol Base64Transformable {

    func decoded() -> String?
    func encoded() -> String
}

extension String: Base64Transformable {

    func decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func encoded() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

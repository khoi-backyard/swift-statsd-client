//
//  FolderType.swift
//  StatsdClient-iOS
//
//  Created by Nghia Tran on 10/10/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

enum Directory {

    case cache
    case document
}

extension Directory {

    var toSearchPath: FileManager.SearchPathDirectory {
        switch self {
        case .cache:
            return .cachesDirectory
        case .document:
            return .documentDirectory
        }
    }
}

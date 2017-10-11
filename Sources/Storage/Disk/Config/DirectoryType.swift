//
//  FolderType.swift
//  StatsdClient-iOS
//
//  Created by Nghia Tran on 10/10/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

enum DirectoryType {

    case cache
    case document

    /// Convert DirectoryType to FileManager.SearchPathDirectory
    /// Because we would like hide unneccessary SearchPathDirectory
    /// - Returns: FileManager.SearchPathDirectory
    var toSearchPath: FileManager.SearchPathDirectory {
        switch self {
        case .cache:
            return .cachesDirectory
        case .document:
            return .documentDirectory
        }
    }
}

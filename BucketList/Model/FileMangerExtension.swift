//
//  FileMangerExtension.swift
//  BucketList
//
//  Created by Mohanad Ramdan on 30/08/2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//
//  FileManagerProtocol.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/23/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

protocol FileManagerProtocol {
    func fileExists(atPath path: String) -> Bool
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
}

extension FileManager: FileManagerProtocol {

}

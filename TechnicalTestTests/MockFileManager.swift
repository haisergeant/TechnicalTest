//
//  MockFileManager.swift
//  TechnicalTestTests
//
//  Created by Hai Le Thanh on 4/23/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation
@testable import TechnicalTest

class MockFileManager: FileManagerProtocol {
    let fileExist: Bool
    
    init(fileExist: Bool) {
        self.fileExist = fileExist
    }
    
    func fileExists(atPath path: String) -> Bool {
        return fileExist
    }
    
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        
    }
}

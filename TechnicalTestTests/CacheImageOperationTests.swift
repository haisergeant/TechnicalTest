//
//  CacheImageOperationTests.swift
//  TechnicalTestTests
//
//  Created by Hai Le Thanh on 4/23/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import XCTest

@testable import TechnicalTest

class CacheImageOperationTests: XCTestCase {
    
    let queue = OperationQueue()
    
    override func setUp() {
        queue.cancelAllOperations()
        
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                 .userDomainMask,
                                                                 true).first!
        let downloadFolder = cacheDirectory + "/" + "Download"
        try? FileManager.default.removeItem(atPath: downloadFolder)
    }

    func testImageDownloadSuccess() {
        let session = MockURLSession()
        let bundle = Bundle(for: CacheImageOperationTests.self)
        session.data = UIImage(named: "tick", in: bundle, compatibleWith: nil)?.pngData()
        
        let fileManager = MockFileManager(fileExist: false)
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns image")
        let operation = CacheImageOperation(url: url, urlSession: session, fileManager: fileManager)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success = result {
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "API should be success")
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testImageDownloadFail() {
        let session = MockURLSession()
        session.error = APIError.invalidImageLink
        
        let fileManager = MockFileManager(fileExist: false)
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API returns error")
        let operation = CacheImageOperation(url: url, urlSession: session, fileManager: fileManager)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.invalidImageLink)
                expectation.fulfill()
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testImageGetFromFileSystemFail() {
        let session = MockURLSession()
        
        let fileManager = MockFileManager(fileExist: true)
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Get image from file system")
        let operation = CacheImageOperation(url: url, urlSession: session, fileManager: fileManager)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.invalidImageLink)
                expectation.fulfill()
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}

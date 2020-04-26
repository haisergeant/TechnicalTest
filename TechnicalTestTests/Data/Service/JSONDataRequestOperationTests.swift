//
//  JSONDataRequestOperationTests.swift
//  TechnicalTestTests
//
//  Created by Hai Le Thanh on 4/23/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import XCTest
@testable import TechnicalTest



class JSONDataRequestOperationTests: XCTestCase {
    let queue = OperationQueue()
    
    override func setUp() {
        queue.cancelAllOperations()
    }
    
    func testAPIRequestSuccess() {
        let session = MockURLSession()
        session.data = "{\"title\":\"Canada\",\"rows\":[{\"title\":\"Beavers\"}]}".data(using: .ascii)
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns correct format")
        let operation = JSONDataRequestOperation<PageData>(url: url, urlSession: session)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let data) = result {
                XCTAssertEqual(data.title, "Canada")
                XCTAssertTrue(data.rows.count == 1)
                XCTAssertEqual(data.rows[0].title, "Beavers")
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "API should be success")
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testAPIRequestReturnError() {
        let session = MockURLSession()
        session.error = APIError.invalidAPIError
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns error")
        let operation = JSONDataRequestOperation<PageData>(url: url, urlSession: session)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
                
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.invalidAPIError)
                expectation.fulfill()
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testAPIRequestReturnInvalidFormat() {
        let session = MockURLSession()
        session.data = "{\"title\":\"Canada\",\"rows\":[{\"title\":\"Beavers}]}".data(using: .ascii)
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns invalid format")
        let operation = JSONDataRequestOperation<PageData>(url: url, urlSession: session)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success = result {
                XCTAssertFalse(true, "API should be fail")
            } else if case .failure(let error) = result {
                XCTAssertEqual(error as? APIError, APIError.jsonFormatError)
                expectation.fulfill()
            }
            
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testAPIRequestIntArray() {
        let session = MockURLSession()
        session.data = "[1,2,3,4,5]".data(using: .ascii)
        
        let url = URL(string: "www.google.com")!
        
        let expectation = self.expectation(description: "Calling API which returns Int array")
        let operation = JSONDataRequestOperation<[Int]>(url: url, urlSession: session)
        operation.completionHandler = { result in
            XCTAssertTrue(operation.isFinished, "Operation must be finished")
            if case .success(let values) = result {
                XCTAssertTrue(values.count == 5)
                expectation.fulfill()
            } else if case .failure = result {
                XCTAssertFalse(true, "API should be fail")
            }
        }
        
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}

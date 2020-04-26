//
//  MockURLSession.swift
//  TechnicalTestTests
//
//  Created by Hai Le Thanh on 4/23/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation
import UIKit
@testable import TechnicalTest

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    var data: Data?
    var error: Error?
    
    func successHttpURLResponse(_ url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(data, successHttpURLResponse(url), error)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    private (set) var cancelWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        cancelWasCalled = true
    }
}

class PageDataURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var data: Data?
    var error: Error?
    var imageData: Data?
    var imageError: Error?
    
    func successHttpURLResponse(_ url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        if url.absoluteString.hasSuffix(".png") || url.absoluteString.hasSuffix(".jpg") {
            completionHandler(imageData, successHttpURLResponse(url), imageError)
        } else {
            completionHandler(data, successHttpURLResponse(url), error)
        }
        return nextDataTask
    }
}

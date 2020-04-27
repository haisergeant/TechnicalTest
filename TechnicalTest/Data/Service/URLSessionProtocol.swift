//
//  URLSessionProtocol.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/23/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

// MARK: - URLSessionProtocol
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}

// MARK: - URLSessionDataTaskProtocol
protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}

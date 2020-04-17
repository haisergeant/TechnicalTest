//
//  JSONDataRequestOperation.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

class JSONDataRequestOperation<T: Decodable>: BaseOperation<T> {
        
    private let urlSession: URLSession
    private let url: URL
    private var dataTask: URLSessionDataTask?
    
    init(url: URL, urlSession: URLSession = .shared) {
        self.url = url
        self.urlSession = urlSession
    }
    
    override func main() {
        dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error {
                    self.complete(result: .failure(error))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    
                    let string = String(data: data, encoding: .ascii)
                    guard let newData = string?.data(using: .utf8) else {
                        self.complete(result: .failure(APIError.jsonFormatError))
                        return
                    }
                    let result = try decoder.decode(T.self, from: newData)
                    self.complete(result: .success(result))
                }
            } catch {
                print(error)
                self.complete(result: .failure(APIError.jsonFormatError))
            }
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
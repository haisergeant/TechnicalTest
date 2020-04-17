//
//  CacheImageOperation.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

class CacheImageOperation: BaseOperation<UIImage> {
    
    private let urlSession: URLSession
    private let url: URL
    private var dataTask: URLSessionDataTask?
    
    init(url: URL, urlSession: URLSession = .shared) {
        self.url = url
        self.urlSession = urlSession
    }
    
    override func main() {
        if let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.absoluteString {
            let fileName = self.url.lastPathComponent
            
            let downloadDirectory = cacheDirectory + "/" + "Download"
            if !FileManager.default.fileExists(atPath: downloadDirectory) {
                try? FileManager.default.createDirectory(atPath: downloadDirectory, withIntermediateDirectories: true)
            }
            
            let fullFileName = downloadDirectory + "/" + fileName
            
            if FileManager.default.fileExists(atPath: fullFileName) {
                guard let image = UIImage(contentsOfFile: fullFileName) else {
                    complete(result: .failure(APIError.invalidImageLink))
                    return
                }
                self.complete(result: .success(image))
            } else {
                dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                    guard let data = data, let image = UIImage(data: data) else {
                        self.complete(result: .failure(APIError.invalidImageLink))
                        return
                    }
                    try? data.write(to: URL(fileURLWithPath: fullFileName))
                    self.complete(result: .success(image))
                }
                dataTask?.resume()
            }
        } else {
            complete(result: .failure(APIError.invalidImageLink))
        }
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
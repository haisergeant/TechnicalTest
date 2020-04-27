//
//  CacheImageOperation.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

// MARK: - CacheImageOperation
final class CacheImageOperation: BaseOperation<UIImage> {
    
    private let urlSession: URLSessionProtocol
    private let fileManager: FileManagerProtocol
    private let url: URL
    private var dataTask: URLSessionDataTaskProtocol?
    
    init(url: URL, urlSession: URLSessionProtocol = URLSession.shared, fileManager: FileManagerProtocol = FileManager.default) {
        self.url = url
        self.urlSession = urlSession
        self.fileManager = fileManager
    }
    
    override func main() {
        if let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let fileName = self.url.lastPathComponent
            
            let downloadDirectory = cacheDirectory + "/" + "Download"
            if !fileManager.fileExists(atPath: downloadDirectory) {
                try? fileManager.createDirectory(atPath: downloadDirectory,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
            }
            
            let fullFileName = downloadDirectory + "/" + fileName
            
            // Retrieve the image in file system if it exists
            if fileManager.fileExists(atPath: fullFileName) {
                guard let image = UIImage(contentsOfFile: fullFileName) else {
                    complete(result: .failure(APIError.invalidImageLink))
                    return
                }
                self.complete(result: .success(image))
            } else {
                dataTask = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
                    guard let self = self else { return }
                    guard let data = data, let image = UIImage(data: data) else {
                        self.complete(result: .failure(APIError.invalidImageLink))
                        return
                    }
                    // Store image in file system for later use
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

//
//  PageDataViewModelTests.swift
//  TechnicalTestTests
//
//  Created by Hai Le Thanh on 4/26/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import XCTest
@testable import TechnicalTest

class MockPageDataView: PageDataViewProtocol {
    var viewModel: PageDataViewModelProtocol!
    var configureIsCalled = false
    var handleErrorIsCalled = false
    var completion: (() -> Void)?
    
    func configure(with viewModel: PageDataViewModelProtocol) {
        self.viewModel = viewModel
        configureIsCalled = true
        completion?()
    }
    
    func handleError(_ error: Error) {
        handleErrorIsCalled = true
        completion?()
    }
}

class PageDataViewModelTests: XCTestCase {
    let queueManager = QueueManager()
    let urlSession = PageDataURLSession()
    
    var viewModel: PageDataViewModel!
    var view: MockPageDataView!
    
    override func setUp() {
        queueManager.cancelAllOperations()
        urlSession.data = nil
        urlSession.error = nil
        urlSession.imageData = nil
        urlSession.imageError = nil
        
        viewModel = PageDataViewModel(queueManager: queueManager,
                                      urlSession: urlSession)
        view = MockPageDataView()
        viewModel.bind(to: view)
        
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                 .userDomainMask,
                                                                 true).first!
        let downloadFolder = cacheDirectory + "/" + "Download"
        try? FileManager.default.removeItem(atPath: downloadFolder)
    }
    
    func testRequestDataSuccess() {
        urlSession.data = "{\"title\":\"Canada\",\"rows\":[{\"title\":\"Beavers\",\"description\":\"Beavers description\",\"imageHref\":\"www.test.com/test.png\"}]}".data(using: .ascii)
        
        viewModel.requestData()
        let expectation = self.expectation(description: "Request data have some RowItems")
        
        view.completion = {
            XCTAssertTrue(self.view.configureIsCalled, "The request should finish and configure function should be called")
            XCTAssertFalse(self.view.handleErrorIsCalled, "Handle error should not be called")
            XCTAssertTrue(self.viewModel.pageTitle() == "Canada", "Title should be same like data return")
            
            XCTAssertTrue(self.viewModel.numberOfRows() == 1, "Should have 1 data row")
            XCTAssertTrue(self.viewModel.cellViewModel(at: 0).title == "Beavers", "Title of first cell should be Beavers")
            XCTAssertTrue(self.viewModel.cellViewModel(at: 0).description == "Beavers description", "Title of first cell should be Beavers description")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestDataFail() {
        urlSession.error = APIError.invalidAPIError
        
        viewModel.requestData()
        let expectation = self.expectation(description: "Request data return fail")
        
        view.completion = {
            XCTAssertFalse(self.view.configureIsCalled, "The request should finish and call handleError")
            XCTAssertTrue(self.view.handleErrorIsCalled, "Handle error should be called")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestImageForRowSuccess() {
        urlSession.data = "{\"title\":\"Canada\",\"rows\":[{\"title\":\"Beavers\",\"description\":\"Beavers description\",\"imageHref\":\"www.test.com/tick.png\"}]}".data(using: .ascii)
        let bundle = Bundle(for: CacheImageOperationTests.self)
        let data = UIImage(named: "tick", in: bundle, compatibleWith: nil)?.pngData()
        urlSession.imageData = data
        
        viewModel.requestData()
        let expectation = self.expectation(description: "Request data for cell successfully")
        
        view.completion = {
            self.viewModel.cellViewModel(at: 0).image.valueChanged = { state in
                switch state {
                case .loadedImage(_):
                    expectation.fulfill()
                default:
                    XCTFail("Should load image successfully")
                }
                
            }
            self.viewModel.requestDataForCellIfNeeded(at: 0)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestImageForRowFail() {
        urlSession.data = "{\"title\":\"Canada\",\"rows\":[{\"title\":\"Beavers\",\"description\":\"Beavers description\",\"imageHref\":\"www.test.com/tick.png\"}]}".data(using: .ascii)
        urlSession.imageError = APIError.invalidImageLink
        
        viewModel.requestData()
        let expectation = self.expectation(description: "Request data for cell fail")
        
        view.completion = {
            self.viewModel.cellViewModel(at: 0).image.valueChanged = { state in
                switch state {
                case .fail:
                    expectation.fulfill()
                default:
                    XCTFail("Should load image fail")
                }                
            }
            self.viewModel.requestDataForCellIfNeeded(at: 0)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

//
//  PageDataViewModel.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

protocol PageDataViewModelProtocol {
    func bind(to view: PageDataViewProtocol)
    func requestData()
    func pageTitle() -> String
    func numberOfRows() -> Int
    func cellViewModel(at index: Int) -> PageItemCellViewModel
}

class PageDataViewModel {
    private weak var view: PageDataViewProtocol?
    private var title: String = ""
    private var rowItems = [RowItem]()
    private var viewModels = [PageItemCellViewModel]()
    private let queueManager: QueueManager
    
    init(queueManager: QueueManager = .shared) {
        self.queueManager = queueManager
    }
}

extension PageDataViewModel: PageDataViewModelProtocol {
    func requestData() {
        guard let url = URL(string: APIConstants.JSON_FEED_URL) else {
            view?.handleError(APIError.invalidAPIError)
            return
        }
        
        let operation = JSONDataRequestOperation<PageData>(url: url)
        operation.completionHandler = { result in
            switch result {
            case .success(let pageData):
                self.title = pageData.title
                self.rowItems = pageData.rows
                
                self.viewModels = self.rowItems.compactMap {
                    PageItemCellViewModel(title: $0.title, description: $0.description)
                }
            case .failure(let error):
                self.view?.handleError(error)
            }
        }
        queueManager.queue(operation)
    }
    
    func bind(to view: PageDataViewProtocol) {
        self.view = view
    }
    
    func pageTitle() -> String {
        return title
    }
    
    func numberOfRows() -> Int {
        return viewModels.count
    }
    
    func cellViewModel(at index: Int) -> PageItemCellViewModel {
        return viewModels[index]
    }
}

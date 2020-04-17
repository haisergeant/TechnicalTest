//
//  PageDataViewModel.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation
import UIKit

protocol PageDataViewModelProtocol {
    func bind(to view: PageDataViewProtocol)
    func requestData()
    func pageTitle() -> String
    func numberOfRows() -> Int
    func cellViewModel(at index: Int) -> PageItemCellViewModel
    func requestDataForCellIfNeeded(at index: Int)
    func stopRequestDataForCell(at index: Int)
}

class PageDataViewModel {
    private weak var view: PageDataViewProtocol?
    private var title: String = ""
    private var rowItems = [RowItem]()
    private var viewModels = [PageItemCellViewModel]()
    private let queueManager: QueueManager
    private var imageOperations: [Int: Operation] = [:]
    
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
                self.rowItems = pageData.rows.filter { $0.title != nil || $0.description != nil || $0.imageHref != nil  }
                
                self.viewModels = self.rowItems.compactMap {
                    PageItemCellViewModel(title: $0.title,
                                          description: $0.description,
                                          image: Observable<UIImage?>(nil))
                }
                DispatchQueue.main.async {
                    self.view?.configure(with: self)
                }                
            case .failure(let error):
                self.view?.handleError(error)
            }
        }
        queueManager.queue(operation)
    }
    
    func requestDataForCellIfNeeded(at index: Int) {
        let viewModel = viewModels[index]
        let rowItem = rowItems[index]
        if viewModel.image.value == nil, let imageURLString = rowItem.imageHref, let url = URL(string: imageURLString) {
            let operation = CacheImageOperation(url: url)
            operation.completionHandler = { result in
                switch result {
                case .success(let image):
                    viewModel.image.value = image
                case .failure(_):
                    break
                }
                self.imageOperations.removeValue(forKey: index)
            }
            queueManager.queue(operation)
            imageOperations[index] = operation
        }
    }
    
    func stopRequestDataForCell(at index: Int) {
        guard let operation = imageOperations[index] else { return }
        operation.cancel()
        imageOperations.removeValue(forKey: index)
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

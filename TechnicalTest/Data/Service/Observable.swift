//
//  Observable.swift
//  WeatherApp
//
//  Created by Hai Le on 9/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

// MARK: - Observable
class Observable<T: Equatable> {
    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if oldValue != self.value {
                    self.valueChanged?(self.value)
                }
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    var valueChanged: ((T) -> Void)?
}

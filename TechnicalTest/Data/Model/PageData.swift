//
//  PageData.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

class PageData: Decodable {
    let title: String
    let rows: [RowItem]
}

class RowItem: Decodable {
    let title: String?
    let description: String?
    let imageHref: String?
}

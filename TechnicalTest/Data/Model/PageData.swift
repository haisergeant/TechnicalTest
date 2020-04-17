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
    
    private enum CodingKeys: String, CodingKey {
        case title
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.rows = try values.decode([RowItem].self, forKey: .rows)
    }
}

class RowItem: Decodable {
    let title: String?
    let description: String?
    let imageHref: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageHref
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try? values.decode(String.self, forKey: .title)
        self.description = try? values.decode(String.self, forKey: .description)
        self.imageHref = try? values.decode(String.self, forKey: .imageHref)
    }
}

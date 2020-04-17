//
//  APIConstants.swift
//  WeatherApp
//
//  Created by Hai Le on 7/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

struct APIConstants {
    static let JSON_FEED_URL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}

enum APIError: Error {
    case invalidAPIError
    case jsonFormatError
}

//
//  ApiError.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import Foundation

// Custom error to be used in api call and parsing
enum ApiError: Error {
    case urlFailed
    case noData
    case requestError
    case parsingFailed
}

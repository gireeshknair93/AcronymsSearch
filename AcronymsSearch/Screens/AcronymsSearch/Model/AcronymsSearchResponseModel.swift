//
//  AcronymsSearchResponseModel.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import Foundation

struct AcronymsSearchResponseModel: Decodable {
    let sf: String
    let lfs: [Acromine]
}

struct Acromine: Decodable {
    let lf: String
    let freq, since: Int
    let vars: [Acromine]?
}

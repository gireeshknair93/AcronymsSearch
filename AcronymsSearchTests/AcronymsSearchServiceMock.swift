//
//  AcronymsSearchServiceMock.swift
//  AcronymsSearchTests
//
//  Created by Gireesh on 11/02/23.
//

import Foundation
@testable import AcronymsSearch

enum ErrorCase {
    case success, failure, emptyResponse
}
class AcronymsSearchServiceMock: AcronymsSearchProtocol {
    
    var testScenario:ErrorCase = .success
    //MARK: Get Acronyms
    func getAcronyms(request: AcronymsSearchRequest, completion: @escaping ([AcronymsSearchResponseModel]?, ApiError?) -> ()) {
        switch testScenario {
        case .success:
            if let data = readLocalFile(forName: "AcronymsResponseStub") {
                let decoder = JSONDecoder()
                if let json = try? decoder.decode([AcronymsSearchResponseModel].self, from: data) {
                    completion(json, nil)
                }
            }
        case .failure:
            completion(nil, .noData)
        case .emptyResponse:
            completion([], nil)
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            guard let url = Bundle(for: AcronymsSearchServiceMock.self).url(forResource: name, withExtension: "json") else {
                return nil
            }
            let jsonData = try String(contentsOfFile: url.path).data(using: .utf8)
            return jsonData
        
        } catch {
            print(error)
        }
        
        return nil
    }
}

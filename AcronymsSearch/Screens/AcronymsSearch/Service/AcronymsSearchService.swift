//
//  AcronymsSearchService.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import Foundation

protocol AcronymsSearchProtocol {
    func getAcronyms(request: AcronymsSearchRequest, completion: @escaping (_ acronyms: [AcronymsSearchResponseModel]?, _ error: ApiError?) -> ())
}

struct AcronymsSearchService: AcronymsSearchProtocol {
    
    //MARK: Get Acronyms
    func getAcronyms(request: AcronymsSearchRequest, completion: @escaping ([AcronymsSearchResponseModel]?, ApiError?) -> ()) {
        var urlComponents = URLComponents(string: ApiEndPoints.search)
        //Adding the query params
        urlComponents?.queryItems = [URLQueryItem(name: ApiParameters.lf, value: request.lf), URLQueryItem(name: ApiParameters.sf, value: request.sf)]
        ApiHandler.shared.callGetService(url: urlComponents?.url, resultModel: [AcronymsSearchResponseModel].self) { result in
            switch result {
            case .success(let acronyms):
                completion(acronyms, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

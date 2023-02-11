//
//  ApiHandler.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import Foundation

struct ApiHandler {
    
    public static let shared = ApiHandler()
    
    //MARK: Get API Call
    func callGetService<T: Decodable>(url: URL?,resultModel: T.Type, result: @escaping((Result<T, ApiError>)->Void)) {
        guard let url = url else {
            return result(.failure(.urlFailed))
        }

        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, _, error in

            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    result(.failure(.noData))
                    return
                }
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(T.self, from: data) {
                    result(.success(json))
                } else {
                    result(.failure(.parsingFailed))
                }
            }
        })
        task.resume()
    }
}

extension ApiHandler {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}

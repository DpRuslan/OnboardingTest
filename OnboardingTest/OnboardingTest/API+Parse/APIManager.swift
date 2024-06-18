//
//  APIManager.swift
//

import Foundation

enum HTTPMethod: String {
    case GET
}

enum CustomError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case dataError
    case urlSession
    case decodingError
    case uknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid Response received"
        case .dataError:
            return "Data error occurred"
        case .urlSession:
            return "Missing Internet connection\nTurn on your internet"
        case .decodingError:
            return "Error decoding"
        case .uknown:
            return "Unknown"
        }
    }
}

final class APIManager {
    let requestStringURL: String
    
    static let shared = APIManager(requestStringURL: URLExtension.requestURL.rawValue)
    
    private init(requestStringURL: String) {
        self.requestStringURL = requestStringURL
    }
    
    func doRequest(completion: @escaping (Result <Data, CustomError>) -> Void) {
        guard let url = URL(string: requestStringURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) {(data, response, error) in
            if let _ = error {
                completion(.failure(.urlSession))
                return
            }
            
            guard let _ = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.dataError))
            }
        }.resume()
    }
}

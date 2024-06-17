//
//  ParseManager.swift
//

import Foundation

enum Status {
    case success(data: Item)
    case failure(error: CustomError)
}

final class ParseManager {
    static let shared = ParseManager()
    
    private init() {}
    
    func parseResponse(data: Data, completion: @escaping(Status) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(Item.self, from: data)
            completion(.success(data: decodedData))
        } catch {
            completion(.failure(error: .decodingError))
        }
    }
}

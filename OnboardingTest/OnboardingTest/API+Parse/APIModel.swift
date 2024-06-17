//
//  APIModel.swift
//

import Foundation

struct Item: Decodable {
    let items: [ItemObject]
}

struct ItemObject: Decodable {
    let id: Int?
    let question: String?
    let answers: [String?]
}

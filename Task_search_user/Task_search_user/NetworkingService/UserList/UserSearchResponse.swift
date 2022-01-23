//
//  SearchResponse.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 17.01.2022.
//

import Foundation

struct UserSearchResponse: Decodable {
    var totalCount: Int?
    var items: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

//
//  SearchResponse.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 17.01.2022.
//

import Foundation

struct UserSearchResponse: Decodable {
    var items: [User]
}

//
//  SearchResponse.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 17.01.2022.
//

import Foundation

struct SearchResponse: Decodable {
    var items: [Users]
}

//MARK: - Users
extension SearchResponse {
    struct Users: Decodable {
        var login: String
        var id: Int
        var avatar: String
        var repositories: String
        var followers: String
        var joined: String
        
        enum CodingKeys: String, CodingKey {
            case login, id
            case avatar = "avatar_url"
            case repositories = "repos_url"
            case followers = "followers_url"
            case joined = "following_url"
        }
    }
}


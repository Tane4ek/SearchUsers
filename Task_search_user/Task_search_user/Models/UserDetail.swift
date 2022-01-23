//
//  DetailUserSearchResponse.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 19.01.2022.
//

import Foundation

struct UserDetail: Decodable {
    let avatar: String
    let name: String?
    let company: String?
    let email: String?
    let followers: Int?
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case company
        case email
        case followers
        case login
        case avatar = "avatar_url"
    }
}

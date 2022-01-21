//
//  UserModel.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 18.01.2022.
//

import Foundation

struct User: Decodable {
    let login: String
    let id: Int
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatar = "avatar_url"
    }
}

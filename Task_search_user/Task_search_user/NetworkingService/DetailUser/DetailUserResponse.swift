//
//  DetailUserSearchResponse.swift
//  Task_search_user
//
//  Created by Поздняков Игорь Николаевич on 19.01.2022.
//

import Foundation

struct DetailUserSearchResponse: Decodable {
    var avatar: String
    var name: String
    var company: String?
    var email: String?
    var followers: Int
    
    enum CodingKeys: String, CodingKey {
        case name, company, email, followers
        case avatar = "avatar_url"
    }
}

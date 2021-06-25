//
//  User.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation

struct User: Decodable {
    var login: String
    var name: String
    var userAvatar: String
    var followers: Int
    var following: Int
    var repositories: Int
    
    enum CodingKeys: String, CodingKey {
        case userAvatar = "avatar_url"
        case repositories = "public_repos"
        case login, name, followers, following
    }
}


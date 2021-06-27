//
//  Repository.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import Foundation

struct Repository: Decodable {
    let name: String?
    let stars: Int
    let owner: Owner
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case stars = "stargazers_count"
        case name, owner, language
    }
}

struct Owner: Decodable {
    var login: String
    
    enum CodingKeys: String, CodingKey {
        case login
    }
}


import Foundation

struct Repository: Decodable {
    let name: String?
    let stars: Int
    let owner: Owner
    let language: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case stars = "stargazers_count"
        case name, owner, language, description
    }
}

struct Owner: Decodable {
    var login: String
    
    enum CodingKeys: String, CodingKey {
        case login
    }
}

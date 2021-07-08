
import Foundation

struct User: Decodable {
    let login: String
    let name: String?
    let userAvatar: String
    let followers: Int?
    let following: Int?
    let repositories: Int?
    let followersURL: String?
    
    enum CodingKeys: String, CodingKey {
        case userAvatar = "avatar_url"
        case repositories = "public_repos"
        case followersURL = "followers_url"
        case login, name, followers, following
    }
}


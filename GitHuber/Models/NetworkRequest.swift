

import Foundation

struct NetworkRequest {
    
    static let keychain = KeychainSwift()
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum RequestError: Error {
        case invalidResponse
        case networkCreationError
        case otherError
        case sessionExpired
    }
    
    enum RequestType {
        case codeExchange(code: String)
        case getRepos(username: String)
        case gerStarredRepos(username:String)
        case getLoggedInUser
        case getUser(username: String)
        case signIn
        case getUserList(username: String, type: UserListViewModel.UserlListType)
        case getRepoContributors(repository: Repository)
        
        func networkRequest() -> NetworkRequest? {
            guard let url = url() else {
                return nil
            }
            return NetworkRequest(method: httpMethod(), url: url)
        }
        
        private func httpMethod() -> NetworkRequest.HTTPMethod {
            switch self {
            case .codeExchange:
                return .post
            case .getRepos:
                return .get
            case .getLoggedInUser:
                return .get
            case .signIn:
                return .get
            case .getUser:
                return .get
            case .getUserList:
                return .get
            case .gerStarredRepos:
                return .get
            case .getRepoContributors:
                return .get
            }
        }
        
        private func url() -> URL? {
            switch self {
            case .codeExchange(let code):
                let queryItems = [
                    URLQueryItem(name: "client_id", value: NetworkRequest.clientID),
                    URLQueryItem(name: "client_secret", value: NetworkRequest.clientSecret),
                    URLQueryItem(name: "code", value: code)
                ]
                return urlComponents(host: "github.com", path: "/login/oauth/access_token", queryItems: queryItems).url
            case .getRepos(let username):
                return urlComponents(path: "/users/\(username)/repos", queryItems: nil).url
            case .getLoggedInUser:
                return urlComponents(path: "/user", queryItems: nil).url
            case .getUser(let username):
                return urlComponents(path: "/users/\(username)", queryItems: nil).url
            case .signIn:
                let queryItems = [
                    URLQueryItem(name: "client_id", value: NetworkRequest.clientID)
                ]
                return urlComponents(host: "github.com", path: "/login/oauth/authorize", queryItems: queryItems).url
            case .getUserList(let username, let type):
                return urlComponents(path: "/users/\(username)/\(type.rawValue)", queryItems: nil).url
            case .gerStarredRepos(username: let username):
                return urlComponents(path: "/users/\(username)/starred", queryItems: nil).url
            case .getRepoContributors(let repository):
                return urlComponents(path: "/repos/\(repository.owner.login)/\(repository.name ?? "")/contributors", queryItems: nil).url
            }
        }
        
        private func urlComponents(host: String = "api.github.com", path: String, queryItems: [URLQueryItem]?) -> URLComponents {
            switch self {
            default:
                var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = host
                urlComponents.path = path
                urlComponents.queryItems = queryItems
                return urlComponents
            }
        }
    }
    
    typealias NetworkResult<T: Decodable> = (response: HTTPURLResponse, object: T)
    
    // MARK: Private Constants
    static let callbackURLScheme = "mygithubberApp"
    static let clientID = "Iv1.9111a4a6e6797093"
    static let clientSecret = "2dd26f07a8d7ae29c9f635f977feb680c4e8b6b3"
    
    // MARK: Properties
    var method: HTTPMethod
    var url: URL
    
    // MARK: Methods
    func start<T: Decodable>(responseType: T.Type, completionHandler: @escaping ((Result<NetworkResult<T>, Error>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let accessToken = UserManager.accessToken {
            request.setValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        print("\(UserManager.accessToken)")
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completionHandler(.failure(RequestError.invalidResponse))
                }
                return
            }
            guard
                error == nil,
                let data = data
            else {
                DispatchQueue.main.async {
                    let error = error ?? NetworkRequest.RequestError.otherError
                    completionHandler(.failure(error))
                }
                return
            }
            
            if T.self == String.self, let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
                let components = responseString.components(separatedBy: "&")
                var dictionary: [String: String] = [:]
                for component in components {
                    let itemComponents = component.components(separatedBy: "=")
                    if let key = itemComponents.first, let value = itemComponents.last {
                        dictionary[key] = value
                    }
                }
                DispatchQueue.main.async {
                    UserManager.accessToken = dictionary["access_token"]
                    UserManager.refreshToken = dictionary["refresh_token"]
                    completionHandler(.success((response, "Success" as! T)))
                }
                return
            } else if let object = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    if let user = object as? User {
                        if UserManager.username == nil {
                            UserManager.username = user.login
                        }
                        completionHandler(.success((response, object)))
                    } else {
                        completionHandler(.success((response, object)))
                    }
                }
                return
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkRequest.RequestError.otherError))
                }
            }
        }
        session.resume()
    }
}

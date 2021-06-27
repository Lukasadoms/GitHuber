//
//  UserListViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import Foundation

class UserListViewModel {
    
    var isLoading = Observable<Bool>(false)
    var userList = Observable<[User]>([])
    
    enum UserlListType {
        case following
        case followers
        
        var rawValue: String {
            switch self {
            case .followers:
                return "followers"
            case .following:
                return "following"
            }
        }
    }
    
    private let user: User
    private let type: UserlListType
    
    init(user: User, type: UserlListType) {
        self.user = user
        self.type = type
    }
    
    func start() {
        getUserList(user: user, type: type)
    }
    
    private func getUserList(user: User, type: UserlListType) {
        isLoading.value = true
        
        NetworkRequest
            .RequestType
            .getUserList(username: user.login, type: type)
            .networkRequest()?
            .start(responseType: [User].self) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.userList.value = response.object
                    print(response)
                case .failure(let error):
                    print("failed to get userList, error: \(error)")
                }
                self?.isLoading.value = false
            }
    }
    
}

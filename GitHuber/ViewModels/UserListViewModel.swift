//
//  UserListViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import UIKit

struct UserListCellModel {
    
    var user: User
    var followerCount: Int?
    
}

class UserListViewModel {
    
    var isLoading = Observable<Bool>(false)
    var userList = Observable<[UserListCellModel]>([])
    
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
                    for user in response.object {
                        var userCellModel = UserListCellModel(user: user)
                        self?.getUserInfo(user: user) { completion in
                            userCellModel.followerCount = completion.followers
                            self?.userList.value.append(userCellModel)
                        }
                    }
                case .failure(let error):
                    print("failed to get userList, error: \(error)")
                }
                self?.isLoading.value = false
            }
    }
    
    private func getUserInfo(user: User, completion: @escaping (User) -> ()) {
        NetworkRequest
            .RequestType
            .getUser(username: user.login)
            .networkRequest()?
            .start(responseType: User.self) { result in
                switch result {
                case .success(let response):
                    completion(response.object)
                case .failure(let error):
                    print("failed to get repositories, error: \(error)")
                }
            }
    }
    
}

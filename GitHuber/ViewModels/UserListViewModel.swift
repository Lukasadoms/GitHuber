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
    var onShowLogin: (() -> Void)?
    
    enum UserlListType {
        case following
        case followers
        case contributors
        
        var rawValue: String {
            switch self {
            case .followers:
                return "followers"
            case .following:
                return "following"
            case .contributors:
                return "contributors"
            }
        }
    }
    
    private let user: User?
    private let type: UserlListType?
    private let users: [User]?
    
    init(user: User?, type: UserlListType?, users: [User]?) {
        self.user = user
        self.type = type
        self.users = users
    }
    
    func start() {
        if let user = user, let type = type {
            getUserListFromAPI(user: user, type: type)
        }
        else {
            loadUserListFromMemory()
        }
    }
    
    private func loadUserListFromMemory() {
        guard let users = users else { return }
        for user in users {
            var userCellModel = UserListCellModel(user: user)
            getUserInfo(user: user) { completion in
                userCellModel.followerCount = completion.followers
                self.userList.value.append(userCellModel)
            }
        }
    }
    
    private func getUserListFromAPI(user: User, type: UserlListType) {
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
                    switch error {
                    case .authenticationError:
                        self?.onShowLogin?()
                    default:
                        print("failed to get userList, error: \(error)")
                    }
                }
            }
    }
    
    private func getUserInfo(user: User, completion: @escaping (User) -> ()) {
        NetworkRequest
            .RequestType
            .getUser(username: user.login)
            .networkRequest()?
            .start(responseType: User.self) { [weak self] result in
                switch result {
                case .success(let response):
                    completion(response.object)
                case .failure(let error):
                    switch error {
                    case .authenticationError:
                        self?.onShowLogin?()
                    default:
                        print("failed to get userInfo, error: \(error)")
                    }
                }
            }
    }
    
}

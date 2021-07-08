//
//  SearchViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 2021-07-03.
//

import Foundation

class SearchViewModel {
    
    var isLoading = Observable<Bool>(false)
    var userList = Observable<[UserListCellModel]>([])
    let repositories = Observable<[Repository]?>(nil)
    var onShowLogin: (() -> Void)?
    
    func searchForUsers(username: String, minFollowers: String?, minRepositories: String?, sortedBy: String ) {
        isLoading.value = true
        
        NetworkRequest
            .RequestType
            .searchUsers(username: username, minimumRepositories: minRepositories, minimumFollowers: minFollowers, sortedBy: sortedBy)
            .networkRequest()?
            .start(responseType: UserSearch.self) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let users = response.object.items else { return }
                    self?.userList.value = []
                    for user in users {
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
                        print("failed to search users, error: \(error)")
                    }
                }
                self?.isLoading.value = false
            }
    }
    
    private func getUserInfo(user: User, completion: @escaping (User) -> ()) {
        NetworkRequest
            .RequestType
            .getUser(username: user.login)
            .networkRequest()?
            .start(responseType: User.self) { [ weak self ]result in
                switch result {
                case .success(let response):
                    completion(response.object)
                case .failure(let error):
                    switch error {
                    case .authenticationError:
                        self?.onShowLogin?()
                    default:
                        print("failed to get repositories, error: \(error)")
                    }
                }
            }
    }
    
    func searchForRepositories(name: String, language: String?, sortedBy: String) {
        isLoading.value = true
        
        NetworkRequest
            .RequestType
            .searchRepositories(
                name: name,
                language: language,
                sortedBy: sortedBy
            )
            .networkRequest()?
            .start(responseType: RepositorySearch.self) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let repos = response.object.items else { return }
                    self?.repositories.value = repos
                    
                case .failure(let error):
                    switch error {
                    case .authenticationError:
                        self?.onShowLogin?()
                    default:
                        print("failed to search repositories, error: \(error)")
                    }
                }
                self?.isLoading.value = false
            }
    }
}

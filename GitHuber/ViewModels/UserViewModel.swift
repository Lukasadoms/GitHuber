//
//  UserViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import UIKit

class UserViewModel {
    
    
    var user: User
    let userDataManager: UserDataManager
    private let keychain: KeychainSwift
    var observableUser = Observable<User?>(nil)
    var userAvatar = Observable<UIImage?>(nil)
    var isLoading = Observable<Bool>(false)
    var errorTitle = Observable<String?>(nil)
    var repositories = [Repository]([])
    var starredRepositories = Observable<[Repository]>([])
    var onShowLogin: (() -> Void)?
    
    init(user: User, keychain: KeychainSwift, userDataManager: UserDataManager) {
        self.keychain = keychain
        self.user = user
        self.userDataManager = userDataManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        getUser(username: user.login)
        observableUser.value = user
        getRepositories(username: user.login)
        getStarredRepositories(username: user.login)
        guard let url = URL(string: user.userAvatar) else { return }
        downloadImage(from: url)
    }
    
    func logoutUser() {
        keychain.clear()
    }
    
    private func getRepositories(username: String) {
        isLoading.value = true
        NetworkRequest
            .RequestType
            .getRepos(username: username)
            .networkRequest()?
            .start(responseType: [Repository].self) { [weak self] result in

                self?.isLoading.value = false
                switch result {
                case .success(let response):
                    self?.repositories = response.object
                    guard self?.user.login == UserManager.username else { return }
                    self?.saveRepositoriesToDatabase(repositories: response.object, starred: false)
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
    
    private func getStarredRepositories(username: String) {
        isLoading.value = true
        NetworkRequest
            .RequestType
            .gerStarredRepos(username: username)
            .networkRequest()?
            .start(responseType: [Repository].self) { [weak self] result in
                self?.isLoading.value = false
                switch result {
                case .success(let response):
                    self?.starredRepositories.value = response.object
                    guard self?.user.login == UserManager.username else { return }
                    self?.saveRepositoriesToDatabase(repositories: response.object, starred: true)
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
    
    private func saveRepositoriesToDatabase(repositories: [Repository], starred: Bool) {
        do {
            try userDataManager.saveAccountRepositories(userName: user.login, repositories: repositories, starred: starred)
        }
        catch {
            errorTitle.value = "failed to save repositories to database"
        }
    }
    
    private func getUser(username: String) {
        isLoading.value = true
        NetworkRequest
            .RequestType
            .getUser(username: username)
            .networkRequest()?
            .start(responseType: User.self) { [weak self] result in
                self?.isLoading.value = false
                switch result {
                case .success(let response):
                    print("success, user: \(response.object.login)")
                    self?.observableUser.value = response.object
                    do {
                        try self?.userDataManager.saveAccountToDatabase(user: response.object)
                    }
                    catch {
                        self?.errorTitle.value = "failed to save account to database"
                    }
                case .failure(let error):
                    switch error {
                    case .authenticationError:
                        self?.onShowLogin?()
                    default:
                        print("Failed to get user, or there is no valid/active session: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let userImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.userAvatar.value = userImage
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

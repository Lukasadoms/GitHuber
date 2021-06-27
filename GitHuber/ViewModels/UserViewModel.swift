//
//  UserViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import UIKit

class UserViewModel: BaseViewModel {
    var isLoading = Observable<Bool>(false)
    var user: User
    private let keychain: KeychainSwift
    var observableUser = Observable<User?>(nil)
    var userAvatar = Observable<UIImage?>(nil)
    
    init(user: User, keychain: KeychainSwift) {
        self.keychain = keychain
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        if user.login != NetworkRequest.username {
            getUser(username: user.login)
        }
        observableUser.value = user
        getRepositories(username: user.login)
        guard let url = URL(string: user.userAvatar) else { return }
        downloadImage(from: url)
        
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
                    print(response)
                case .failure(let error):
                    print("failed to get repositories, error: \(error)")
                }
                
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
                case .failure(let error):
                    print("Failed to get user, or there is no valid/active session: \(error.localizedDescription)")
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

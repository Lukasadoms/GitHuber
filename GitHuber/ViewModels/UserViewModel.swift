//
//  UserViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import UIKit

class UserViewModel {
    private var isLoading = Observable<Bool>(false)
    var user: User
    private let keychain: KeychainSwift
    var observableUser = Observable<User?>(nil)
    var userAvatar = Observable<UIImage?>(nil)
    
    init(user: User, keychain: KeychainSwift) {
        self.keychain = keychain
        self.user = user
    }
    
    func start() {
        observableUser.value = user
        guard let observableUser = observableUser.value else { return }
        getRepositories(username: observableUser.login)
        print(observableUser.login)
        guard let url = URL(string: observableUser.userAvatar) else { return }
        downloadImage(from: url)
    }
    
    private func getRepositories(username: String) {
        isLoading.value = true
        
        NetworkRequest
            .RequestType
            .getRepos(username: username)
            .networkRequest()?
            .start(responseType: [Repository].self) { [weak self] result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print("failed to get repositories, error: \(error)")
                }
                self?.isLoading.value = false
            }
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                guard let image = UIImage(data: data) else { return }
                self?.userAvatar.value = image
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

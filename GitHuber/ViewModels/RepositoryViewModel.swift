//
//  RepositoryViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/27/21.
//

import Foundation

class RepositoryViewModel {
    let isLoading = Observable<Bool>(false)
    let repository = Observable<Repository?>(nil)
    let contributors = Observable<[User]>([])
    
    init(repository: Repository) {
        self.repository.value = repository
    }
    
    func start() {
        guard let repository = repository.value else { return }
        getRepoContributors(repository: repository)
    }
    
    private func getRepoContributors(repository: Repository) {
        
        NetworkRequest
            .RequestType
            .getRepoContributors(repository: repository)
            .networkRequest()?
            .start(responseType: [User].self) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.contributors.value = response.object
                case .failure(let error):
                    print(error)
                }
                self?.isLoading.value = false
            }
    }
}

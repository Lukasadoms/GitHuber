//
//  RepositoryListViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/27/21.
//

import Foundation

class RepositoryListViewModel {
    
    var repositories: [Repository]
    
    init(repositories: [Repository]) {
        self.repositories = repositories
    }
}

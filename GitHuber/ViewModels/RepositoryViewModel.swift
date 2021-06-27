//
//  RepositoryViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/27/21.
//

import Foundation

struct RepositoryViewModel {
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
}

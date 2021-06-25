//
//  UserListViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import Foundation

class UserListViewModel {
    
    private let user: User
    private let type: String
    
    init(user: User, type: String) {
        self.user = user
        self.type = type
    }
    
}

//
//  DependancyContainer.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation

class DependencyContainer {
//    lazy var apiManager = APIManager(userManager: userManager)
    lazy var keychain = KeychainSwift()
//    lazy var userManager = UserManager(keyChain: keychain)
//    lazy var cityManager = CityManager(userDefaults: .standard)
//    lazy var webLoginManager = WebLoginManager(
//        userManager: userManager,
//        apiManager: apiManager
//    )
    lazy var oAuthManager = OAuthManager()
}

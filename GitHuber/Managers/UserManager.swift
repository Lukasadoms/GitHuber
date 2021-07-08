//
//  UserManager.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation

struct UserManager {
    
    static let keychain = KeychainSwift()
    
    // MARK: Private Constants
    private static let accessTokenKey = "accessToken"
    private static let refreshTokenKey = "refreshToken"
    private static let tokenExpiresIn = "expiresIn"
    private static let usernameKey = "username"
    
    // MARK: Properties
    static var accessToken: String? {
        get {
            keychain.get(accessTokenKey)
        }
        set {
            guard let accessToken = newValue else { return }
            keychain.set(accessToken, forKey: accessTokenKey)
        }
    }
    
    static var refreshToken: String? {
        get {
            keychain.get(refreshTokenKey)
        }
        set {
            guard let refreshToken = newValue else { return }
            keychain.set(refreshToken, forKey: refreshTokenKey)
        }
    }
    
    static var tokenExpiration: String? {
        get {
            UserDefaults.standard.string(forKey: tokenExpiresIn)
        }
        set {
            guard let tokenExpiration = newValue else { return }
            let nowDate = Int(Date().timeIntervalSince1970)
            let expirationDate = Int(tokenExpiration)! + nowDate
            UserDefaults.standard.setValue(expirationDate, forKey: tokenExpiresIn)
        }
    }
    
    static var username: String? {
        get {
            keychain.get(usernameKey)
        }
        set {
            guard let username = newValue else { return }
            keychain.set(username, forKey: usernameKey)
        }
    }
    
    static func isUserLoggedIn() -> Bool {
        guard let expirationTimestamp = tokenExpiration else {
            return false
        }
        let currentTimestamp = Date().timeIntervalSince1970
        return Int(expirationTimestamp) ?? 0 > Int(currentTimestamp)
    }
}

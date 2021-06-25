//
//  NetworkRequest+User.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation

extension NetworkRequest {
    
  // MARK: Private Constants
  private static let accessTokenKey = "accessToken"
  private static let refreshTokenKey = "refreshToken"
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
      UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: refreshTokenKey)
    }
  }

  static var username: String? {
    get {
      UserDefaults.standard.string(forKey: usernameKey)
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: usernameKey)
    }
  }
}

//
//  LoginViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation
import AuthenticationServices

class LoginViewModel: NSObject {
    let oAuthManager: OAuthManager
    var isLoading = false
    
    var onLogin: (() -> Void)?
    
    init(oAuthManager: OAuthManager) {
        self.oAuthManager = oAuthManager
    }
    
    func getLoginURL() -> URL {
        return oAuthManager.getAuthPageUrl()
    }
    
    func loginUser() {
        guard let signInURL =
          NetworkRequest.RequestType.signIn.networkRequest()?.url
        else {
          print("Could not create the sign in URL .")
          return
        }

        let callbackURLScheme = NetworkRequest.callbackURLScheme
        let authenticationSession = ASWebAuthenticationSession(
          url: signInURL,
          callbackURLScheme: callbackURLScheme) { [weak self] callbackURL, error in
          // 1
          guard
            error == nil,
            let callbackURL = callbackURL,
            // 2
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
            // 3
            let code = queryItems.first(where: { $0.name == "code" })?.value,
            // 4
            let networkRequest =
              NetworkRequest.RequestType.codeExchange(code: code).networkRequest()
          else {
            // 5
            print("An error occurred when attempting to sign in.")
            return
          }

          self?.isLoading = true
          networkRequest.start(responseType: String.self) { result in
            switch result {
            case .success:
              self?.getUser()
            case .failure(let error):
              print("Failed to exchange access code for tokens: \(error)")
              self?.isLoading = false
            }
          }
        }

        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = true

        if !authenticationSession.start() {
          print("Failed to start ASWebAuthenticationSession")
        }
    }
    
    func appeared() {
      // Try to get the user in case the tokens are already stored on this device
      getUser()
    }
    
    private func getUser() {
      isLoading = true

      NetworkRequest
        .RequestType
        .getUser
        .networkRequest()?
        .start(responseType: User.self) { [weak self] result in
          switch result {
          case .success(let user):
            print("success, token: \(NetworkRequest.accessToken ?? "a") \(user)")
            self?.onLogin?()
          case .failure(let error):
            print("Failed to get user, or there is no valid/active session: \(error.localizedDescription)")
          }
          self?.isLoading = false
        }
    }
}

extension LoginViewModel: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession)
  -> ASPresentationAnchor {
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    return window ?? ASPresentationAnchor()
  }
}

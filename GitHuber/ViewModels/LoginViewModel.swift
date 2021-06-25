//
//  LoginViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation
import AuthenticationServices

class LoginViewModel: NSObject {
    private var isLoading = Observable<Bool>(false)
    
    var onLogin: ((_ user: User) -> Void)?
    
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

            self?.isLoading.value = true
          networkRequest.start(responseType: String.self) { result in
            switch result {
            case .success:
              self?.getLoggedInUser()
            case .failure(let error):
              print("Failed to exchange access code for tokens: \(error)")
                self?.isLoading.value = false
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
      getLoggedInUser()
    }
    
    private func getLoggedInUser() {
        isLoading.value = true

      NetworkRequest
        .RequestType
        .getLoggedInUser
        .networkRequest()?
        .start(responseType: User.self) { [weak self] result in
          switch result {
          case .success(let response):
            print("success, user: \(response.object.login)")
            self?.onLogin?(response.object)
          case .failure(let error):
            print("Failed to get user, or there is no valid/active session: \(error.localizedDescription)")
          }
            self?.isLoading.value = false
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

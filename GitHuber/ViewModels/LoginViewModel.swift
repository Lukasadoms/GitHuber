//
//  LoginViewModel.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation
import AuthenticationServices

class LoginViewModel: NSObject {
    
    var isLoading = Observable<Bool>(false)
    var onLogin: ((_ user: User) -> Void)?
    let userDataManager: UserDataManager
    
    init(userDataManager: UserDataManager) {
        self.userDataManager = userDataManager
    }
    
    func loginUser() {
        isLoading.value = true
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
            guard
                error == nil,
                let callbackURL = callbackURL,
                let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
                let code = queryItems.first(where: { $0.name == "code" })?.value,
                let networkRequest =
                    NetworkRequest.RequestType.codeExchange(code: code).networkRequest()
            else {
                print("An error occurred when attempting to sign in.")
                self?.isLoading.value = false
                return
            }
            networkRequest.start(responseType: String.self) { result in
                switch result {
                case .success(let data):
                    self?.getLoggedInUser()
                    print(data)
                case .failure(let error):
                    print("Failed to exchange access code for tokens: \(error)")
                }
            }
            self?.isLoading.value = false
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
        
        NetworkRequest
            .RequestType
            .getLoggedInUser
            .networkRequest()?
            .start(responseType: User.self) { [weak self] result in
                switch result {
                case .success(let response):
                    print("success, user: \(response.object)")
                    self?.isLoading.value = false
                    self?.onLogin?(response.object)
                case .failure(let error):
                    print("Failed to get user, or there is no valid/active session: \(error.localizedDescription)")
                    guard let username = UserManager.username else { return }
                    do {
                        guard let userData = try self?.userDataManager.getAccountFromDatabase(accountLogin: username) else { return }
                        let user = User(login: userData.username ?? "" , name: userData.fullname, userAvatar: "", followers: Int(userData.followers ?? ""), following: Int(userData.following ?? ""), repositories: Int(userData.repositories ?? ""), followersURL: userData.followersURL)
                        self?.onLogin?(user)
                    }
                    catch {
                        print (error)
                    }
                    self?.isLoading.value = false
                }
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

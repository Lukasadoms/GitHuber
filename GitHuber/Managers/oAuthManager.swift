//
//  oAuthManager.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import Foundation

class OAuthManager {
    
    private var state: String?
    
    func getAuthPageUrl() -> URL {
        state = UUID().uuidString
        let urlString = "https://github.com/login/oauth/authorize?client_id=8e3fb9b0a3cabf23003d&redirect_uri=com.lukasadomavicius.githubber://main&s&scopes=repo,user&state=\(state!)"
        
        return URL(string: urlString)!
    }
}

//
//  UserDataManager.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 2021-07-05.
//

import UIKit
import CoreData

struct UserDataManager {
    
    func saveAccountRepositories(
        userName: String,
        repositories: [Repository],
        starred: Bool
    ) throws {
        let account = try getAccountFromDatabase(accountLogin: userName)
        for repository in repositories {
            if starred {
                let repositoryData = RepositoryData(context: CoreDataManager.managedContext)
                repositoryData.language = repository.language
                repositoryData.name = repository.name
                repositoryData.owner = repository.owner.login
                repositoryData.stars = "\(repository.stars)"
                guard let account = account else { return }
                account.addToRepository(repositoryData)
            } else {
                let repositoryData = StarredRepositoryData(context: CoreDataManager.managedContext)
                repositoryData.language = repository.language
                repositoryData.name = repository.name
                repositoryData.owner = repository.owner.login
                repositoryData.stars = "\(repository.stars)"
                guard let account = account else { return }
                account.addToStarredRepository(repositoryData)
            }
        }
        do {
            try CoreDataManager.saveContext()
        }
        catch {
            throw error
        }
    }
    
    func saveAccountToDatabase(user: User) throws {
        let account = UserData(context: CoreDataManager.managedContext)
        account.followers = "\(user.followers ?? 0)"
        account.following = "\(user.following ?? 0)"
        account.fullname = user.name
        account.username = user.login
        account.repositories = "\(user.repositories ?? 0)"
        if let url = URL(string: user.userAvatar) {
            downloadImage(from: url) { completion in
                account.userAvatar = completion.pngData()
            }
        }
        do {
            try CoreDataManager.saveContext()
        }
        catch {
            throw error
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> () ) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    let image = #imageLiteral(resourceName: "appLogo")
                    completion(image)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getAccountFromDatabase (accountLogin: String) throws -> UserData? {

        do {
            let fetchRequest : NSFetchRequest<UserData> = UserData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", accountLogin)
            let fetchedResults = try CoreDataManager.managedContext.fetch(fetchRequest)
            if let account = fetchedResults.first {
                return account
            }
        }
        catch {
            throw error
        }
        return nil
    }
}

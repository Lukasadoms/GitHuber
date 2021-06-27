//
//  UserListCell.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/26/21.
//

import UIKit

final class UserListCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    let userInfo = User?(nil)
    
    func configureCell(user: User) {
        guard let url = URL(string: user.userAvatar) else { return }
        downloadImage(from: url)
        getUserInfo(user: user)
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        guard let userInfo = userInfo else { return }
        userNameLabel.text = userInfo.login
        followersLabel.text = "Followers: \(userInfo.followers ?? 0)"
    }
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.userImageView.image = #imageLiteral(resourceName: "appLogo")
                }
                return
            }
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func getUserInfo(user: User) {
        NetworkRequest
            .RequestType
            .getUser(username: user.login)
            .networkRequest()?
            .start(responseType: User.self) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.followersLabel.text = "Followers: \(response.object.followers ?? 0 )"
                    
                    print(response)
                case .failure(let error):
                    print("failed to get repositories, error: \(error)")
                }
            }
    }
}

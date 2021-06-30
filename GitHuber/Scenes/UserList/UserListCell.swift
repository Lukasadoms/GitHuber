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
    
    func configureCell(user: UserListCellModel) {
        guard let url = URL(string: user.user.userAvatar) else { return }
        userImageView.image = #imageLiteral(resourceName: "appLogo")
        userImageView.image?.downloadImage(from: url) { completion in
            self.userImageView.image = completion
        }
        userNameLabel.text = user.user.login
        followersLabel.text = "Followers: \(user.followerCount ?? 0)"
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
    }
    
    
}

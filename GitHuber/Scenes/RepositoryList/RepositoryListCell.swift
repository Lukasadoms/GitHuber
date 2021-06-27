//
//  RepositoryListCell.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/27/21.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryOwnerLabel: UILabel!
    @IBOutlet weak var repositoryLanguageLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    
    func setupCell(repository: Repository) {
        repositoryNameLabel.text = repository.name
        repositoryOwnerLabel.text = repository.owner.login
        repositoryLanguageLabel.text = "Language: \(repository.language ?? "N/A")"
        starsCountLabel.text = "Stars: \(repository.stars)"
    }
}

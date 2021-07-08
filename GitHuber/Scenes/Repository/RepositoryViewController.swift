//
//  RepositoryViewController.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/26/21.
//

import UIKit

class RepositoryViewController: UIViewController {
    
    let viewModel: RepositoryViewModel
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var contributorsButton: UIButton!
    
    init(viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.repository.bind { repository in
            guard let repository = repository else { return }
            self.repositoryNameLabel.text = repository.name
            self.ownerLabel.text = "Owner: \(repository.owner.login)"
            self.numberOfStarsLabel.text = "Starred: \(repository.stars)"
            self.languageLabel.text = "Language: \(repository.language ?? "N/A")"
        }
        
        viewModel.contributors.bind { contributors in
            self.contributorsButton.setTitle("Contributors: \(contributors.count)", for: .normal)
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.view.showBlurLoader()
            }
            else {
                self?.view.removeBluerLoader()
            }
        }
        
        viewModel.onShowLogin = { [weak self] in self?.showLogin() }
    }
    
    func showLogin() {
        coordinator?.start()
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        //TODO
    }
    
    @IBAction func contributorsButtonTapped(_ sender: UIButton) {
        coordinator?.startUserListViewController(user: nil, type: .contributors, users: viewModel.contributors.value)
    }
}

//
//  MainViewController.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import UIKit

class UserViewController: UIViewController {
    
    private let viewModel: UserViewModel
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var repositoriesButton: UIButton!
    @IBOutlet weak var staredReposButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.start()
        setupView()
    }
    
    func bindViewModel() {
        viewModel.userAvatar.bind { userAvatar in
            self.userImage.image = userAvatar            
        }
        
        viewModel.observableUser.bind { user in
            guard
                let user = user,
                let followers = user.followers,
                let following = user.following,
                let repositories = user.repositories
            else { return }
            self.followersButton.setTitle("Followers: \(followers)", for: .normal)
            self.followingButton.setTitle("Following: \(following)", for: .normal)
            self.repositoriesButton.setTitle("Repos: \(repositories)", for: .normal)
            self.usernameLabel.text = user.login
            self.fullNameLabel.text = user.name
        }
        
        viewModel.starredRepositories.bind { repositories in
            self.staredReposButton.setTitle("Starred Repos: \(repositories.count)", for: .normal)
        }
        
        viewModel.isLoading.bind { isLoading in
            if isLoading {
                self.view.showBlurLoader()
            }
            else {
                self.view.removeBluerLoader()
            }
        }
    }
    
    func setupView() {
        
        if viewModel.user.login == NetworkRequest.username {
            navigationItem.hidesBackButton = true
            followButton.isHidden = true
            configureNavigationBar()
            logoutButton.isHidden = false
        }
        self.title = "GitHuber"
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
    
    func configureNavigationBar() {
        let img = UIImage(systemName: "gear")!
        let imgWidth = img.size.width
        let imgHeight = img.size.height
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        button.setBackgroundImage(img, for: .normal)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .darkGray
    }
    
    @objc func settingsButtonPressed() {
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
    }
    
    @IBAction func followersButtonTapped(_ sender: Any) {
        coordinator?.startUserListViewController(user: viewModel.user, type: .followers)
    }
    
    @IBAction func followingButtonTapped(_ sender: Any) {
        coordinator?.startUserListViewController(user: viewModel.user, type: .following)
    }
    
    @IBAction func reposButtonTapped(_ sender: Any) {
        coordinator?.startRepositoryListViewController(repositories: viewModel.repositories)
    }
    
    @IBAction func starredReposTapped(_ sender: Any) {
        coordinator?.startRepositoryListViewController(repositories: viewModel.starredRepositories.value)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        viewModel.logoutUser()
        coordinator?.logout()
    }
}

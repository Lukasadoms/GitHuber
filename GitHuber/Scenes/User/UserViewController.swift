//
//  MainViewController.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/24/21.
//

import UIKit

class UserViewController: UIViewController {
    
    // MARK: Properties
    
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
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: LifeCycle
    
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
    
    // MARK: UI Setup
    
    func bindViewModel() {
        viewModel.userAvatar.bind { [weak self] userAvatar in
            self?.userImage.image = userAvatar            
        }
        
        viewModel.observableUser.bind { [weak self] user in
            guard
                let user = user,
                let followers = user.followers,
                let following = user.following,
                let repositories = user.repositories
            else { return }
            self?.followersButton.setTitle("Followers: \(followers)", for: .normal)
            self?.followingButton.setTitle("Following: \(following)", for: .normal)
            self?.repositoriesButton.setTitle("Repos: \(repositories)", for: .normal)
            self?.usernameLabel.text = user.login
            self?.fullNameLabel.text = user.name
        }
        
        viewModel.starredRepositories.bind { [weak self] repositories in
            self?.staredReposButton.setTitle("Starred Repos: \(repositories.count)", for: .normal)
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.view.showBlurLoader()
            }
            else {
                self?.view.removeBluerLoader()
            }
        }
        
        viewModel.errorTitle.bind { [weak self] errorTitle in
            guard let errorTitle = errorTitle else { return }
            
            self?.showErrorAlert(title: errorTitle)
        }
        
        viewModel.onShowLogin = { [weak self] in self?.showLogin() }
    }
    
    func setupView() {
        if viewModel.user.login == UserManager.username {
            navigationItem.hidesBackButton = true
            followButton.isHidden = true
            configureNavigationBar()
            logoutButton.isHidden = false
            searchButton.isHidden = false
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
    
    // MARK: Navigation
    
    @objc func settingsButtonPressed() {
        showErrorAlert(title: "This function has not been implemented yet, check back soon :)")
        //TODO
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        coordinator?.startSearchViewController()
    }
    
    @IBAction func followersButtonTapped(_ sender: Any) {
        coordinator?.startUserListViewController(user: viewModel.user, type: .followers, users: nil)
    }
    
    @IBAction func followingButtonTapped(_ sender: Any) {
        coordinator?.startUserListViewController(user: viewModel.user, type: .following, users: nil)
    }
    
    @IBAction func reposButtonTapped(_ sender: Any) {
        coordinator?.startRepositoryListViewController(repositories: viewModel.repositories.value)
    }
    
    @IBAction func starredReposTapped(_ sender: Any) {
        coordinator?.startRepositoryListViewController(repositories: viewModel.starredRepositories.value)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        viewModel.logoutUser()
        coordinator?.logout()
    }
    
    func showLogin() {
        coordinator?.start()
    }
}

// MARK: Alert Method

extension UserViewController {
    private func showErrorAlert(title: String) {
        let alertViewController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertViewController, animated: true)
    }
}

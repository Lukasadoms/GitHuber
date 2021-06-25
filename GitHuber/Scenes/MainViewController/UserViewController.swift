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
            guard let user = user else { return }
            self.followersButton.setTitle("Followers: \(user.followers)", for: .normal)
            self.followingButton.setTitle("Following: \(user.following)", for: .normal)
            self.repositoriesButton.setTitle("Repos: \(user.repositories)", for: .normal)
            self.usernameLabel.text = user.login
            self.fullNameLabel.text = user.name
        }
    }
    
    func setupView() {
        if viewModel.user.login == NetworkRequest.username {
            navigationItem.hidesBackButton = true
            followButton.isHidden = true
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .black
        configureNavigationBar()
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
    }
    
    @objc func settingsButtonPressed() {
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
    }
    
    @IBAction func followersButtonTapped(_ sender: Any) {
        coordinator?.startUserListViewController(user: viewModel.user, type: "followers")
    }
    
    @IBAction func followingButtonTapped(_ sender: Any) {
        coordinator?.startUserListViewController(user: viewModel.user, type: "following")
    }
    
    @IBAction func reposButtonTapped(_ sender: Any) {
    }
    
    @IBAction func starredReposTapped(_ sender: Any) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        coordinator?.logout()
    }
}

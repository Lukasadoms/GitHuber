//
//  UserListViewController.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import UIKit

class UserListViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: UserListViewModel
    weak var coordinator: MainCoordinator?
    @IBOutlet weak var userListTableView: UITableView!
    
    // MARK: LifeCycle
    
    init(viewModel: UserListViewModel) {
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
        setupTableView()
        setupView()
    }
    
    // MARK: UI Setup
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "GitHubers List"
    }
    
    func bindViewModel() {
        viewModel.userList.bind { userlist in
            self.userListTableView.reloadData()
        }
        
        viewModel.isLoading.bind { isLoading in
            if isLoading {
                self.view.showBlurLoader()
            }
            else {
                self.view.removeBluerLoader()
            }
        }
        
        viewModel.onShowLogin = { [weak self] in self?.showLogin() }
    }
    
    func showLogin() {
        coordinator?.start()
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: "UserListCell", bundle: nil)
        userListTableView.register(cellNib, forCellReuseIdentifier: "UserListCell")

        userListTableView.dataSource = self
        userListTableView.delegate = self
    }
}

// MARK: UITableViewMethods

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath)

        guard
            let userListCell = cell as? UserListCell
        else {
            return cell
        }

        let user = viewModel.userList.value[indexPath.row]
        userListCell.configureCell(user: user)

        return userListCell
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.userList.value[indexPath.row]
        coordinator?.startUserViewController(user: user.user)
    }
}

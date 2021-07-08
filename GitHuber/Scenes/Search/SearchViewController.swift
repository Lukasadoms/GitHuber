//
//  SearchViewController.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 2021-07-03.
//

import UIKit

class SearchViewController: UIViewController {
    
    let viewModel: SearchViewModel
    weak var coordinator: MainCoordinator?
    private let UserSortStrings = ["followers", "repositories", "author-date"]
    private let RepositorySortStrings = ["stars", "forks", "updated"]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchModePicker: UISegmentedControl!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var repositorySortPicker: UISegmentedControl!
    @IBOutlet weak var minRepositpriesTextField: UITextField!
    @IBOutlet weak var minFollowersTextField: UITextField!
    @IBOutlet weak var usersSortPicker: UISegmentedControl!
    @IBOutlet weak var repositoryFilterStackView: UIStackView!
    @IBOutlet weak var userFilterStackView: UIStackView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userCellNib = UINib(nibName: "UserListCell", bundle: nil)
        resultsTableView.register(userCellNib, forCellReuseIdentifier: "UserListCell")
        let repositoryCellNib = UINib(nibName: "RepositoryListCell", bundle: nil)
        resultsTableView.register(repositoryCellNib, forCellReuseIdentifier: "RepositoryListCell")
        
        self.title = "Search"
        bindViewModel()
        startSearch()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        minRepositpriesTextField.delegate = self
        minFollowersTextField.delegate = self
        languageTextField.delegate = self
        searchBar.delegate = self
        userFilterStackView.isHidden = true
        repositoryFilterStackView.isHidden = true
    }
    
    func bindViewModel() {
        viewModel.userList.bind { [weak self] userList in
            self?.resultsTableView.reloadData()
        }
        
        viewModel.repositories.bind { [weak self] repositories in
            self?.resultsTableView.reloadData()
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
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        if searchModePicker.selectedSegmentIndex == 0 {
            userFilterStackView.isHidden = !userFilterStackView.isHidden
        } else {
            repositoryFilterStackView.isHidden = !repositoryFilterStackView.isHidden
        }
        UIView.animate(withDuration: 0.5, animations: view.layoutIfNeeded)
    }
    
    @IBAction func searchPickerChangedValue(_ sender: UIPickerView) {
        startSearch()
        languageTextField.text = ""
        minFollowersTextField.text = ""
        minRepositpriesTextField.text = ""
        usersSortPicker.selectedSegmentIndex = 0
        repositorySortPicker.selectedSegmentIndex = 0
        userFilterStackView.isHidden = true
        repositoryFilterStackView.isHidden = true
    }
    
    @IBAction func sortPickerChangedValue(_ sender: UISegmentedControl) {
        startSearch()
    }
    
    func getUserList() {
        guard let text = searchBar.text else { return }
        viewModel.searchForUsers(
            username: text,
            minFollowers: minFollowersTextField.text,
            minRepositories: minRepositpriesTextField.text,
            sortedBy: UserSortStrings[usersSortPicker.selectedSegmentIndex]
        )
    }
    
    func getRepositoryList() {
        guard let
                searchBarText = searchBar.text,
                searchBarText != ""
        else { return }
        
        viewModel.searchForRepositories(
            name: searchBarText,
            language: languageTextField.text,
            sortedBy: RepositorySortStrings[repositorySortPicker.selectedSegmentIndex]
        )
    }
    
    func startSearch() {
        if searchModePicker.selectedSegmentIndex == 0 {
            getUserList()
        } else {
            getRepositoryList()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchModePicker.selectedSegmentIndex == 0 {
            return viewModel.userList.value.count
        } else {
            guard let repositories = viewModel.repositories.value else { return 0 }
            return repositories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchModePicker.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath)

            guard
                let userListCell = cell as? UserListCell
            else {
                return cell
            }

            let user = viewModel.userList.value[indexPath.row]
            userListCell.configureCell(user: user)

            return userListCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath)

            guard
                let repositoryListCell = cell as? RepositoryTableViewCell
            else {
                return cell
            }

            guard let repository = viewModel.repositories.value?[indexPath.row] else { return cell }
            repositoryListCell.setupCell(repository: repository)

            return repositoryListCell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchModePicker.selectedSegmentIndex == 0 {
            let user = viewModel.userList.value[indexPath.row]
            coordinator?.startUserViewController(user: user.user)
        } else {
            guard let repository = viewModel.repositories.value?[indexPath.row] else { return }
            coordinator?.startRepositoryViewController(repository: repository)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        startSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}



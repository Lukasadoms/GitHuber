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
    private let sortStrings = ["followers", "repositories", "author-date"]
    
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
        
        let cellNib = UINib(nibName: "UserListCell", bundle: nil)
        resultsTableView.register(cellNib, forCellReuseIdentifier: "UserListCell")

        bindViewModel()
        getUserList()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        searchBar.delegate = self
        userFilterStackView.isHidden = true
        repositoryFilterStackView.isHidden = true
    }
    
    func bindViewModel() {
        viewModel.userList.bind { [weak self] userList in
            self?.resultsTableView.reloadData()
        }
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
        
        userFilterStackView.isHidden = true
        repositoryFilterStackView.isHidden = true
    }
    @IBAction func userSortPickerChangedValue(_ sender: UISegmentedControl) {
        getUserList()
    }
    
    func getUserList() {
        guard let text = searchBar.text else { return }
        viewModel.postUserSearchQuery(
            username: text,
            minFollowers: minFollowersTextField.text,
            minRepositories: minRepositpriesTextField.text,
            sortedBy: sortStrings[usersSortPicker.selectedSegmentIndex]
        )
    }
}

extension SearchViewController: UITableViewDataSource {
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

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getUserList()
    }
}



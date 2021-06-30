//
//  RepositoryList.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/26/21.
//

import UIKit

class RepositoryListViewController: UIViewController {
    
    let viewModel: RepositoryListViewModel
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var repositoryListTableView: UITableView!
    
    init(viewModel: RepositoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: "RepositoryListCell", bundle: nil)
        repositoryListTableView.register(cellNib, forCellReuseIdentifier: "RepositoryListCell")
        repositoryListTableView.dataSource = self
        repositoryListTableView.delegate = self
        self.title = "GitHuber Repos List"
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath)

        guard
            let repositoryListCell = cell as? RepositoryTableViewCell
        else {
            return cell
        }

        let repository = viewModel.repositories[indexPath.row]
        repositoryListCell.setupCell(repository: repository)

        return repositoryListCell
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories[indexPath.row]
        coordinator?.startRepositoryViewController(repository: repository)
    }
}

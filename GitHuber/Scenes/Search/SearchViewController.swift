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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchModePicker: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var repositoryFilterStackView: UIStackView!
    @IBOutlet weak var userFilterStackView: UIStackView!
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        userFilterStackView.isHidden = true
        repositoryFilterStackView.isHidden = true
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
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension SearchViewController: UITableViewDelegate {
    
}



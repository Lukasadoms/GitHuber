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
    
    init(viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

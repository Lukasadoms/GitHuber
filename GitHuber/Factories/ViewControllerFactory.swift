
import Foundation

protocol ViewControllersFactory {

    func makeLoginViewController() -> LoginViewController
    func makeUserViewController(user: User) -> UserViewController
    func makeUserListViewController(user: User?, type: UserListViewModel.UserlListType?, users: [User]?) -> UserListViewController
    func makeRepositoryListViewController(repositories: [Repository]) -> RepositoryListViewController
    func makeRepositoryViewController(repository: Repository) -> RepositoryViewController
}

extension DependencyContainer: ViewControllersFactory {
    func makeUserListViewController(user: User?, type: UserListViewModel.UserlListType?, users: [User]? ) -> UserListViewController {
        let viewModel = UserListViewModel(user: user, type: type, users: users)
        let userListViewController = UserListViewController(viewModel: viewModel)
        return userListViewController
    }
    
    func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: viewModel)
        return loginViewController
    }
    
    func makeUserViewController(user: User) -> UserViewController {
        let viewModel = UserViewModel(user: user, keychain: keychain)
        let userViewController = UserViewController(viewModel: viewModel)
        return userViewController
    }
    
    func makeRepositoryListViewController(repositories: [Repository]) -> RepositoryListViewController {
        let viewModel = RepositoryListViewModel(repositories: repositories)
        let repositoryViewController = RepositoryListViewController(viewModel: viewModel)
        return repositoryViewController
    }
    
    func makeRepositoryViewController(repository: Repository) -> RepositoryViewController {
        let viewModel = RepositoryViewModel(repository: repository)
        let repositoryViewController = RepositoryViewController(viewModel: viewModel)
        return repositoryViewController
    }
}

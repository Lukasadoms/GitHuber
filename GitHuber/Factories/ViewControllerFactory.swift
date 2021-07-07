
import Foundation

protocol ViewControllersFactory {

    func makeLoginViewController(userDataManager: UserDataManager) -> LoginViewController
    func makeUserViewController(user: User) -> UserViewController
    func makeUserListViewController(user: User?, type: UserListViewModel.UserlListType?, users: [User]?) -> UserListViewController
    func makeRepositoryListViewController(repositories: [Repository]) -> RepositoryListViewController
    func makeRepositoryViewController(repository: Repository) -> RepositoryViewController
    func makeSearchViewController() -> SearchViewController
}

extension DependencyContainer: ViewControllersFactory {
    func makeUserListViewController(user: User?, type: UserListViewModel.UserlListType?, users: [User]? ) -> UserListViewController {
        let viewModel = UserListViewModel(user: user, type: type, users: users)
        let userListViewController = UserListViewController(viewModel: viewModel)
        return userListViewController
    }
    
    func makeLoginViewController(userDataManager: UserDataManager) -> LoginViewController {
        let viewModel = LoginViewModel(userDataManager: userDataManager)
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
    
    func makeSearchViewController() -> SearchViewController {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: viewModel)
        return searchViewController
    }
}

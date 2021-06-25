
import Foundation

protocol ViewControllersFactory {

    func makeLoginViewController() -> LoginViewController
    func makeUserViewController(user: User) -> UserViewController
    func makeUserListViewController(user: User, type: String) -> UserListViewController
}

extension DependencyContainer: ViewControllersFactory {
    func makeUserListViewController(user: User, type: String) -> UserListViewController {
        let viewModel = UserListViewModel(user: user, type: type)
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
}

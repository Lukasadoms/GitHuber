
import UIKit

class MainCoordinator {
    
    var navigationController: UINavigationController
    private let viewControllersFactory: ViewControllersFactory
    
    init(controller: UINavigationController,
         viewControllersFactory: ViewControllersFactory) {
        self.navigationController = controller
        self.viewControllersFactory = viewControllersFactory
    }
    
    func start() {
        startLoginViewController()
    }
    
    func startLoginViewController() {
        let loginViewController = viewControllersFactory.makeLoginViewController()
        loginViewController.coordinator = self
        
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func startUserViewController(user: User) {
        let userViewController = viewControllersFactory.makeUserViewController(user: user)
        userViewController.coordinator = self
        navigationController.pushViewController(userViewController, animated: true)
    }
    
    func startUserListViewController(user: User?, type: UserListViewModel.UserlListType?, users: [User]? ) {
        let userListViewController = viewControllersFactory.makeUserListViewController(user: user, type: type, users: users)
        userListViewController.coordinator = self
        navigationController.pushViewController(userListViewController, animated: true)
    }
    
    func startRepositoryListViewController(repositories: [Repository]) {
        let repositoryListViewController = viewControllersFactory.makeRepositoryListViewController(repositories: repositories)
        repositoryListViewController.coordinator = self
        navigationController.pushViewController(repositoryListViewController, animated: true)
    }
    
    func startRepositoryViewController(repository: Repository) {
        let repositoryViewController = viewControllersFactory.makeRepositoryViewController(repository: repository)
        repositoryViewController.coordinator = self
        navigationController.pushViewController(repositoryViewController, animated: true)
    }
    
    func startSearchViewController() {
        let searchViewController = viewControllersFactory.makeSearchViewController()
        searchViewController.coordinator = self
        navigationController.pushViewController(searchViewController, animated: true)
    }

    func logout() {
        navigationController.popViewController(animated: true)
    }
}

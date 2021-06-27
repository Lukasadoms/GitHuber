
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
    
    func startUserListViewController(user: User, type: UserListViewModel.UserlListType ) {
        let userListViewController = viewControllersFactory.makeUserListViewController(user: user, type: type)
        userListViewController.coordinator = self
        navigationController.pushViewController(userListViewController, animated: true)
    }

    func logout() {
        navigationController.popViewController(animated: true)
    }
}

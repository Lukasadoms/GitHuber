
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
        startHomeViewController()
    }
    
    func startHomeViewController() {
        let loginViewController = viewControllersFactory.makeLoginViewController()
        loginViewController.coordinator = self
        
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func startMainViewController() {
        let mainViewController = viewControllersFactory.makeMainViewController()
        
        navigationController.pushViewController(mainViewController, animated: true)
    }
//    
//    func startRegisterProblem() {
//        let registerProblemViewController = viewControllersFactory.makeRegisterProblemViewController()
//        registerProblemViewController.coordinator = self
//        
//        navigationController.present(registerProblemViewController, animated: true, completion: nil)
//    }
//    
//    func startLogin(delegate: LoginViewControllerDelegate?) {
//        let loginViewController = viewControllersFactory.makeLoginViewController()
//        loginViewController.modalPresentationStyle = .fullScreen
//        loginViewController.delegate = delegate
//        navigationController.present(loginViewController, animated: true, completion: nil)
//    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}

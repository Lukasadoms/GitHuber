
import Foundation

protocol ViewControllersFactory {

    func makeLoginViewController() -> LoginViewController
    func makeMainViewController() -> MainViewController
}

extension DependencyContainer: ViewControllersFactory {

    func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel(oAuthManager: oAuthManager)
        let loginViewController = LoginViewController(viewModel: viewModel)
        return loginViewController
    }
    
    func makeMainViewController() -> MainViewController {
        let MainViewController = MainViewController()
        return MainViewController
    }
}

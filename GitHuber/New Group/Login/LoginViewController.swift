
import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bindViewModel() {
        viewModel.onLogin = {
            self.coordinator?.startMainViewController()
        }
        viewModel.appeared()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.loginUser()
    }
}

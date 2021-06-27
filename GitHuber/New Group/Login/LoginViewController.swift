
import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bindViewModel() {
        
        viewModel.appeared()
        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                //self?.view.showBlurLoader()
            }
            else {
                self?.view.removeBluerLoader()
            }
        }
        viewModel.onLogin = { [weak self] user in
            self?.coordinator?.startUserViewController(user: user)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.loginUser()
    }
}

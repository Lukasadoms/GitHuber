

import Foundation

class DependencyContainer {
    lazy var keychain = KeychainSwift()
    lazy var userDataManager = UserDataManager()
}

import Foundation
import SwiftUI
import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get }
    func start()
}

final class Coordinator: CoordinatorProtocol {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let listViewModel = ListViewModel()
        listViewModel.navigationDelegate = self
        let viewController = ListViewController(viewModel: listViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension Coordinator: ListNavigationDelegate {
    func goToDetail(withId: String) {
        let view = DetailView()
        let viewController = UIHostingController<DetailView>(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
}

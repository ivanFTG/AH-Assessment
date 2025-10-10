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
    func goToDetail(with idUrl: String) {
        let viewModel = DetailViewModel(idUrl: idUrl)
        let view = DetailView(viewModel: viewModel)
        let viewController = UIHostingController<DetailView>(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
}

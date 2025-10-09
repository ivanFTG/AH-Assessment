import Foundation
import UIKit

final class ListViewController: UIViewController {
    struct State {
        let firstLoad: Bool
        let artList: [String]
    }

    let viewModel: ListViewModel

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        Task {
            await startObservation()
        }
    }

    private func startObservation() async {
        let streamOfStates = Observations { [weak self] in
            guard let self = self else {
                return State(firstLoad: false, artList: [])
            }
            return State(firstLoad: self.viewModel.firstLoad, artList: self.viewModel.artList)
        }

        for await state in streamOfStates {
            updateUI(with: state)
        }
    }

    private func updateUI(with state: State) {
        print(state)
    }

    private func setupViews() {
        view.backgroundColor = .appBackground

        let label = UILabel()
        label.text = "This is the list screen"
        label.textColor = .appTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

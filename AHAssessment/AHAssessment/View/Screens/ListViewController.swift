import Foundation
import UIKit

final class ListViewController: UIViewController {
    struct State {
        let firstLoad: Bool
        let artList: [String]

        static let initial = State(firstLoad: false, artList: [])
    }

    private let viewModel: ListViewModel
    private var viewState: State = .initial

    private let collectionView = View.collectionView()

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
        viewState = state
        collectionView.reloadData()
    }

    private func setupViews() {
        view.backgroundColor = .appBackground

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ListCollectionViewCell.self,
            forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier
        )

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private enum View {
        static func collectionView() -> UICollectionView {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }
    }
}

extension ListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let loadThreshold: CGFloat = 200

        if offset + visibleHeight + loadThreshold >= contentHeight {
            Task { [weak self] in
                await self?.viewModel.loadNextPage()
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 56)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.artList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard indexPath.row < viewState.artList.count else { return UICollectionViewCell() }
        cell.configure(with: "\(indexPath.row + 1) - \(viewState.artList[indexPath.row])")
        return cell
    }
}

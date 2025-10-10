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
    private let searchController = View.searchController()

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
        Task { [weak self] in
            await self?.startObservation()
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
        title = "Rijks Museum Collection"
        view.backgroundColor = .appCellBackground

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        view.addSubview(collectionView)
        collectionView.backgroundColor = .appBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ListCollectionViewCell.self,
            forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier
        )

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private enum View {
        static func collectionView() -> UICollectionView {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }

        static func searchController() -> UISearchController {
            let search = UISearchController(searchResultsController: nil)
            search.obscuresBackgroundDuringPresentation = false
            search.hidesNavigationBarDuringPresentation = false
            search.searchBar.autocapitalizationType = .none
            search.searchBar.autocorrectionType = .no
            return search
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetailView(for: indexPath.row)
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width - 32, height: 160)
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
        cell.configure(with: viewState.artList[indexPath.row])
        return cell
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.searchTextChanged(text)
    }
}

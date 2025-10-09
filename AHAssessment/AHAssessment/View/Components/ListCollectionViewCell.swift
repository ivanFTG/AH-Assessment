import Foundation
import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ListCollectionViewCell"

    struct State {
        let detail: DetailModel?

        static let initial = State(detail: nil)
    }

    private let detailView = View.detail()
    private let viewModel = ListCollectionViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        Task { [weak self] in
            await self?.startObservation()
        }
    }

    private func startObservation() async {
        let streamOfStates = Observations { [weak self] in
            guard let self = self else {
                return State(detail: nil)
            }
            return State(detail: viewModel.detail)
        }

        for await state in streamOfStates {
            updateUI(with: state)
        }
    }

    override func prepareForReuse() {
        viewModel.resetDetail()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with idUrl: String) {
        Task { [weak self] in
            await self?.viewModel.configure(with: idUrl)
        }
    }

    private func updateUI(with state: State) {
        guard let detail = state.detail else {
            detailView.reset()
            return
        }
        detailView.configure(with: detail)
    }

    private func setupView() {
        contentView.addSubview(detailView)

        contentView.backgroundColor = .appCellBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }

    private enum View {
        static func detail() -> ListCellView {
            let detail = ListCellView()
            detail.translatesAutoresizingMaskIntoConstraints = false
            return detail
        }
    }
}

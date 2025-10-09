import Foundation
import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ListCollectionViewCell"

    private let loadingLabel = View.label()
    private let detailView = View.detail()
    private let isLoading = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        loadingLabel.text = text
    }

    private func setupView() {
        contentView.addSubview(detailView)
        contentView.addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            loadingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            loadingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            detailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            detailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            detailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }

    private enum View {
        static func label() -> UILabel {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 0
            label.textColor = .appPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }

        static func detail() -> ListCellView {
            let detail = ListCellView()
            detail.translatesAutoresizingMaskIntoConstraints = false
            return detail
        }
    }
}

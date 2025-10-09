import Foundation
import UIKit

final class ListCellView: UIView {
    static let imageSize: CGFloat = 80

    private let imageView = View.imageView()
    private let titleLabel = View.titleLabel()
    private let authorLabel = View.authorLabel()
    private let dateLabel = View.dateLabel()

    init() {
        super.init(frame: .zero)

        setupView()
    }

    func configure(with detail: DetailModel) {
        imageView.image = UIImage(resource: .cellPlaceHolder)
        titleLabel.text = detail.briefTitle
        authorLabel.text = detail.author
        dateLabel.text = detail.date
    }

    private func setupView() {
        layer.cornerRadius = 16

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: ListCellView.imageSize),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private enum View {
        static func imageView() -> UIImageView {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }

        static func titleLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            label.numberOfLines = 0
            label.textColor = .appPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }

        static func authorLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .body)
            label.textColor = .appTextPrimary
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }

        static func dateLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .caption1)
            label.textColor = .appTextSecondary
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
    }
}

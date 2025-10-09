import Foundation
import UIKit

final class ListCellView: UIView {
    static let imageSize: CGFloat = 120

    private let imageView = View.imageView()
    private let titleLabel = View.titleLabel()
    private let authorLabel = View.authorLabel()
    private let dateLabel = View.dateLabel()
    private let labelsStack = View.labelsStack()

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

    func reset() {
        imageView.image = UIImage(resource: .cellPlaceHolder)
        titleLabel.text = nil
        authorLabel.text = nil
        dateLabel.text = nil
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(labelsStack)

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        [titleLabel, authorLabel, spacer, dateLabel].forEach(labelsStack.addArrangedSubview)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: ListCellView.imageSize),

            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            labelsStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            labelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
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
            label.font = UIFont.preferredFont(forTextStyle: .headline)
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

        static func labelsStack() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }
    }
}

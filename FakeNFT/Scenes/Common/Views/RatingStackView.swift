import UIKit

final class RatingStackView: UIStackView {

    private let maxRating = 5
    private lazy var starViews: [UIImageView] = (0..<maxRating).map { _ in
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRating(_ rating: Int) {
        for (index, star) in starViews.enumerated() {
            star.tintColor = index < rating ? .yellowUniversal : .segmentInactive
        }
    }

    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 2
        starViews.forEach { addArrangedSubview($0) }
    }
}

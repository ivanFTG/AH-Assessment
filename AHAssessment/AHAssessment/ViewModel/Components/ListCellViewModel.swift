import Foundation
import UIKit

@Observable
final class ListCellViewModel {
    var image: UIImage?

    private let cache: CacheProtocol

    init(cache: CacheProtocol = ApiCache.shared) {
        self.cache = cache
    }

    func configureWith(imageDataUrl: String?, size: CGFloat) async {
        guard let imageDataUrl else { return }
        do {
            image = try await cache.loadImage(for: imageDataUrl, size: size)
        } catch {
            print(error) // we do nothing just leave the placeholder
        }
    }
}

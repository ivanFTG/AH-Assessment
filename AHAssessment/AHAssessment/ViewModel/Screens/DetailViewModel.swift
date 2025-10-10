import Foundation
import SwiftUI

@Observable
final class DetailViewModel {
    var detailItem = DetailModel.placeHolderDetail
    var image: UIImage?
    var isLoading = true

    private let imageWidth: CGFloat = 1320 // iPhone Max has the biggest screen width in pixels

    private let cache: CacheProtocol

    init(idUrl: String, cache: CacheProtocol = ApiCache()) {
        self.cache = cache

        Task {
            await fetchDetail(from: idUrl)
            await fetchImage()
        }
    }

    private func fetchDetail(from idUrl: String) async {
        do {
            detailItem = try await cache.loadDetail(for: idUrl)
        } catch {
            print(error)
        }
    }

    private func fetchImage() async {
        defer {
            isLoading = false
        }
        guard let imageUrl = detailItem.imageDataUrls?.first else {
            image = UIImage(resource: .cellPlaceHolder)
            return
        }
        do {
            let uiImage = try await cache.loadImage(for: imageUrl, size: imageWidth)
            image = uiImage
        } catch {
            image = UIImage(resource: .cellPlaceHolder)
        }
    }
}


private extension DetailModel {
    static let placeHolderDetail = DetailModel(
        identifier: "",
        date: String.placeHolder(for: 8),
        author: String.placeHolder(for: 16),
        briefTitle: String.placeHolder(for: 16),
        briefSubtitle: String.placeHolder(for: 24),
        briefDescription: String.placeHolder(for: 64),
        height: String.placeHolder(for: 4),
        width: String.placeHolder(for: 4),
        locationCode: String.placeHolder(for: 4),
        locationDescription: String.placeHolder(for: 8),
        description: String.placeHolder(for: 64),
        imageDataUrls: nil
    )
}

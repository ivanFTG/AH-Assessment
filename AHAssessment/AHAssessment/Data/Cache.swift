import Foundation
import UIKit

protocol StoreProtocol: Actor {
    func getDetailItem(for idUrl: String) throws -> DetailModel?
    func getImage(for idUrl: String) throws -> UIImage?
    func setDetailItem(_ item: DetailModel, for idUrl: String)
    func setImage(_ image: UIImage, for idUrl: String)
}

protocol CacheProtocol {
    func loadDetail(for idUrl: String) async throws(AppError) -> DetailModel
    func loadImage(for imageUrl: String, size: CGFloat) async throws(AppError) -> UIImage
}

final class ApiCache: CacheProtocol {
    static let shared = ApiCache()

    private let api: ApiProtocol
    private let store: StoreProtocol

    init(api: ApiProtocol = Api(), store: StoreProtocol = Store()) {
        self.api = api
        self.store = store
    }

    func loadDetail(for idUrl: String) async throws(AppError) -> DetailModel {
        guard let detail = try? await store.getDetailItem(for: idUrl) else {
            let detail = try await api.fetchDetail(for: idUrl)
            await store.setDetailItem(detail, for: idUrl)
            return detail
        }
        print("Load Detail from cache: \(idUrl)")
        return detail
    }

    func loadImage(for imageUrl: String, size: CGFloat) async throws(AppError) -> UIImage {
        var imageIIIFUrl = try await api.fetchIIIFImageUrl(for: imageUrl)
        imageIIIFUrl = imageIIIFUrl.replacingOccurrences(of: "max", with: "\(size)")

        guard let image = try? await store.getImage(for: imageIIIFUrl) else {
            let imageData = try await api.downloadImage(for: imageIIIFUrl)
            guard let image = UIImage(data: imageData) else {
                throw AppError.wrongResponse
            }
            await store.setImage(image, for: imageIIIFUrl)
            return image
        }
        print("Load Image from cache: \(imageUrl)")
        return image
    }
}

actor Store: StoreProtocol {
    private var loadedItems: [String: DetailModel] = [:]
    private var loadedImages: [String: UIImage] = [:]

    func getDetailItem(for idUrl: String) throws -> DetailModel? {
        loadedItems[idUrl]
    }

    func getImage(for idUrl: String) throws -> UIImage? {
        loadedImages[idUrl]
    }

    func setDetailItem(_ item: DetailModel, for idUrl: String) {
        loadedItems[idUrl] = item
    }

    func setImage(_ image: UIImage, for idUrl: String) {
        loadedImages[idUrl] = image
    }
}

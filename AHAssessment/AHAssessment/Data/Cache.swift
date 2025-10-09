import Foundation
import UIKit

protocol StoreProtocol: Actor {
    func getDetailItem(for idUrl: String) throws -> DetailModel?
    func getImage(for idUrl: String) throws -> UIImage?
    func setDetailItem(_ item: DetailModel, for idUrl: String)
    func setImage(_ image: UIImage, for idUrl: String)
}

protocol CacheProtocol {
    func loadDetail(for id: String) async throws(AppError) -> DetailModel
}

final class ApiCache: CacheProtocol {
    static let shared = ApiCache()

    private let api: ApiProtocol
    private let store: StoreProtocol

    init(api: ApiProtocol = Api(), store: StoreProtocol = Store()) {
        self.api = api
        self.store = store
    }

    func loadDetail(for id: String) async throws(AppError) -> DetailModel {
        guard let detail = try? await store.getDetailItem(for: id) else {
            return try await api.fetchDetail(for: id)
        }
        return detail
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

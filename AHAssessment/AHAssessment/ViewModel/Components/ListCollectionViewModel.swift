import Foundation

@Observable
final class ListCollectionViewModel {
    var detail: DetailModel?
    var errorMessage: String?

    private let cache: CacheProtocol

    init(cache: CacheProtocol = ApiCache.shared) {
        self.cache = cache
    }

    func configure(with idUrl: String) async {
        do {
            detail = try await cache.loadDetail(for: idUrl)
        } catch {
            errorMessage = error.errorDescription
        }
    }

    func resetDetail() {
        detail = nil
        errorMessage = nil
    }
}

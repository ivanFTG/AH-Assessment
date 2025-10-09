import Foundation

@Observable
final class ListCollectionViewModel {
    var detail: DetailModel?

    private let cache: CacheProtocol

    init(cache: CacheProtocol = ApiCache.shared) {
        self.cache = cache
    }

    func configure(with idUrl: String) async {
        do {
            detail = try await cache.loadDetail(for: idUrl)
        } catch {
            print(error)
        }
    }

    func resetDetail() {
        detail = nil
    }
}

import Foundation

protocol ListNavigationDelegate: AnyObject {
    func goToDetail(withId: String)
}

@Observable
final class ListViewModel {
    private let api: ApiProtocol
    weak var navigationDelegate: ListNavigationDelegate?

    var firstLoad = false
    var artList: [String] = []
    var nextPageUrl: String?

    private var blockMorePageLoading = false

    init(api: ApiProtocol = Api()) {
        self.api = api

        Task { [weak self] in
            await self?.loadFirstPage()
        }
    }

    private func loadFirstPage() async {
        defer {
            firstLoad = false
            blockMorePageLoading = false
        }

        firstLoad = true
        blockMorePageLoading = true
        do {
            let newListPage = try await api.searchRequest(pageUrl: nextPageUrl, description: nil)
            artList = newListPage.itemUrls
            nextPageUrl = newListPage.nextPageUrl
        } catch {
            print(error)
        }
    }

    func loadNextPage() async {
        guard !blockMorePageLoading else { return }
        defer {
            blockMorePageLoading = false
        }
        blockMorePageLoading = true
        do {
            let newListPage = try await api.searchRequest(pageUrl: nextPageUrl, description: nil)
            artList.append(contentsOf: newListPage.itemUrls)
            nextPageUrl = newListPage.nextPageUrl
        } catch {
            print(error)
        }
    }
}

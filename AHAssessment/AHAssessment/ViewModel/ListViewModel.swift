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

    init(api: ApiProtocol = Api()) {
        self.api = api

        Task {
            await loadFirstPage()
        }
    }

    private func loadFirstPage() async {
        defer {
            firstLoad = false
        }
        do {
            firstLoad = true
            let newListPage = try await api.searchRequest(description: nil)
            artList = newListPage.itemUrls
            nextPageUrl = newListPage.nextPageUrl
        } catch {
            print(error)
        }
    }
}

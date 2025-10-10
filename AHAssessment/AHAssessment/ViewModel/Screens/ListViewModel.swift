import Foundation

protocol ListNavigationDelegate: AnyObject {
    func goToDetail(with idUrl: String)
}

@Observable
final class ListViewModel {
    private let api: ApiProtocol
    var navigationDelegate: ListNavigationDelegate?

    var firstLoad = false
    var artList: [String] = []
    var nextPageUrl: String?
    var errorMessage: String?

    private var blockMorePageLoading = false
    private var searchTask: Task<Void, Never>?

    init(api: ApiProtocol = Api()) {
        self.api = api

        Task { [weak self] in
            await self?.loadFirstPage(with: nil)
        }
    }

    func loadNextPage() async {
        guard let nextPageUrl else { return }
        guard !blockMorePageLoading else { return }
        defer {
            blockMorePageLoading = false
        }
        blockMorePageLoading = true
        do {
            let newListPage = try await api.searchRequest(pageUrl: nextPageUrl, description: nil)
            artList.append(contentsOf: newListPage.itemUrls)
            self.nextPageUrl = newListPage.nextPageUrl
        } catch {
            errorMessage = error.errorDescription
        }
    }

    func searchTextChanged(_ text: String) {
        searchTask?.cancel()

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard let self = self, !Task.isCancelled else { return }

            if text.isEmpty || text.count >= 5 {
                nextPageUrl = nil
                artList = []
                await loadFirstPage(with: text)
            }
        }
    }

    func showDetailView(for index: Int) {
        guard index < artList.count else { return }
        navigationDelegate?.goToDetail(with: artList[index])
    }

    private func loadFirstPage(with searchDescription: String?) async {
        defer {
            firstLoad = false
            blockMorePageLoading = false
        }

        firstLoad = true
        blockMorePageLoading = true
        do {
            let newListPage = try await api.searchRequest(pageUrl: nextPageUrl, description: searchDescription)
            artList = newListPage.itemUrls
            nextPageUrl = newListPage.nextPageUrl
        } catch {
            errorMessage = error.errorDescription
        }
    }
}

import Foundation
@testable import AHAssessment

extension Api {
    final class Mock: ApiProtocol {
        static let error = AppError.response(errorCode: 300)
        var showError = false
        private var searchResults: [ListModel] = []

        private(set) var searchCallCount = 0
        private(set) var lastPageUrl: String?
        private(set) var lastDescription: String?

        func addSearchResult(result: ListModel) {
            searchResults.append(result)
        }

        func searchRequest(pageUrl: String?, description: String?) async throws(AppError) -> ListModel {
            searchCallCount += 1
            lastPageUrl = pageUrl
            lastDescription = description

            guard !showError else { throw Mock.error }
            if searchResults.isEmpty {
                return ListModel(nextPageUrl: nil, itemUrls: [])
            } else {
                return searchResults.removeFirst()
            }
        }

        func fetchDetail(for idUrl: String) async throws(AppError) -> DetailModel {
            fatalError("Not implemented")
        }

        func fetchIIIFImageUrl(for imageUrl: String) async throws(AppError) -> String {
            fatalError("Not implemented")
        }

        func downloadImage(for imageUrl: String) async throws(AppError) -> Data {
            fatalError("Not implemented")
        }
    }
}

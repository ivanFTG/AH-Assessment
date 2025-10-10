import Foundation
import Testing
@testable import AHAssessment

@Suite("ListViewModel Tests")
struct ListViewModelTests {
    @Test("Initial load successfully shows artList")
    func initialLoadSucceed() async throws {
        let api = Api.Mock()
        api.addSearchResult(result: ListModel.mock)

        let viewModel = ListViewModel(api: api)

        while viewModel.firstLoad {
            try await Task.sleep(for: .milliseconds(50))
        }

        await Task.yield()

        #expect(viewModel.artList == ListModel.mock.itemUrls)
        #expect(viewModel.nextPageUrl == ListModel.mock.nextPageUrl)
        #expect(api.searchCallCount >= 1)
        #expect(api.lastDescription == nil)
    }

    @Test("Initial load fails")
    func initialLoadFails() async throws {
        let api = Api.Mock()
        api.showError = true

        let viewModel = ListViewModel(api: api)
        while viewModel.firstLoad {
            try await Task.sleep(for: .milliseconds(50))
        }

        await Task.yield()

        #expect(viewModel.artList.isEmpty)
        #expect(viewModel.nextPageUrl == nil)
        #expect(viewModel.errorMessage == Api.Mock.error.errorDescription)
    }
}

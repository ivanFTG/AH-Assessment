import Foundation

protocol ApiProtocol {
    func searchRequest(description: String?) async throws(AppError) -> ListModel
}

final class Api: ApiProtocol {
    func searchRequest(description: String?) async throws(AppError) -> ListModel {
        var baseURLString = "https://data.rijksmuseum.nl/search/collection"
        if let description {
            baseURLString = "\(baseURLString)?description=\(description)"
        }
        guard let url = URL(string: baseURLString) else {
            throw AppError.url
        }
        let request = URLRequest(url: url)
        let result: (data: Data, response: URLResponse) = try await doRequest(for: request)
        guard let response = result.response as? HTTPURLResponse else {
            throw AppError.wrongResponse
        }
        switch response.statusCode {
        case 200:
            return try await decode(data: result.data)
        default:
            throw AppError.wrongResponse
        }
    }

    @concurrent private func decode<T: Decodable>(data: Data) async throws(AppError) -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw AppError.decoding
        }
    }

    private func doRequest(for urlRequest: URLRequest) async throws(AppError) -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw AppError.urlSession
        }
    }
}

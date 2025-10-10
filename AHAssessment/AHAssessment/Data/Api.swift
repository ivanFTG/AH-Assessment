import Foundation

protocol ApiProtocol {
    func searchRequest(pageUrl: String?, description: String?) async throws(AppError) -> ListModel
    func fetchDetail(for idUrl: String) async throws(AppError) -> DetailModel
    func fetchIIIFImageUrl(for imageUrl: String) async throws(AppError) -> String
    func downloadImage(for imageUrl: String) async throws(AppError) -> Data
}

final class Api: ApiProtocol {
    func searchRequest(pageUrl: String?, description: String?) async throws(AppError) -> ListModel {
        var baseURLString = pageUrl ?? "https://data.rijksmuseum.nl/search/collection"
        if let description {
            baseURLString = "\(baseURLString)?description=\(description)"
        }
        guard let url = URL(string: baseURLString) else {
            throw AppError.url
        }
        return try await doRequest(url: url)
    }

    func fetchDetail(for idUrl: String) async throws(AppError) -> DetailModel {
        guard let url = URL(string: idUrl) else {
            throw AppError.url
        }
        return try await doRequest(url: url)
    }

    func fetchIIIFImageUrl(for imageUrl: String) async throws(AppError) -> String {
        let visualItem = try await fetchVisualItemUrl(for: imageUrl)
        guard let modelUrl = visualItem.idUrl else {
            throw AppError.url
        }
        let imageModel = try await fetchImageModel(for: modelUrl)
        guard let imageUrl = imageModel.url else {
            throw AppError.url
        }
        return imageUrl
    }

    func downloadImage(for imageUrl: String) async throws(AppError) -> Data {
        guard let url = URL(string: imageUrl) else {
            throw AppError.url
        }
        let request = URLRequest(url: url)
        let result: (data: Data, response: URLResponse) = try await sendToUrlSession(for: request)
        guard let response = result.response as? HTTPURLResponse else {
            throw AppError.wrongResponse
        }
        switch response.statusCode {
        case 200:
            return result.data
        default:
            throw AppError.response(errorCode: response.statusCode)
        }
    }

    private func fetchVisualItemUrl(for imageUrl: String) async throws(AppError) -> VisualItemModel {
        guard let url = URL(string: imageUrl) else {
            throw AppError.url
        }
        return try await doRequest(url: url)
    }

    private func fetchImageModel(for modelUrl: String) async throws(AppError) -> ImageModel {
        guard let url = URL(string: modelUrl) else {
            throw AppError.url
        }
        return try await doRequest(url: url)
    }

    private func doRequest<T: Decodable>(url: URL) async throws(AppError) -> T {
        let request = URLRequest(url: url)
        let result: (data: Data, response: URLResponse) = try await sendToUrlSession(for: request)
        guard let response = result.response as? HTTPURLResponse else {
            throw AppError.wrongResponse
        }
        switch response.statusCode {
        case 200:
            return try await decode(data: result.data)
        default:
            throw AppError.response(errorCode: response.statusCode)
        }
    }

    private func sendToUrlSession(for urlRequest: URLRequest) async throws(AppError) -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw AppError.urlSession
        }
    }

    private func decode<T: Decodable>(data: Data) async throws(AppError) -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw AppError.decoding
        }
    }
}

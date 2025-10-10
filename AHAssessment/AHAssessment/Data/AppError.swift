import Foundation

enum AppError: LocalizedError {
    case url
    case urlSession
    case wrongResponse
    case response(errorCode: Int)
    case decoding

    var errorDescription: String? {
        switch self {
        case .url:
            "There was a problem with the URL"
        case .urlSession:
            "There was a problem when sending the request"
        case .wrongResponse:
            "There was a problem with the server response"
        case .response(let errorCode):
            "Error in response with code: \(errorCode)"
        case .decoding:
            "Error decoding the response"
        }
    }
}

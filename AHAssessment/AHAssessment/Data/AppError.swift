import Foundation

enum AppError: LocalizedError {
    case url
    case urlSession
    case wrongResponse
    case response(errorCode: Int)
    case decoding
}

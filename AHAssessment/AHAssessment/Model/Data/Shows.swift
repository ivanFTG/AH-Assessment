import Foundation

struct Shows: Decodable, Sendable {
    let identifier: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

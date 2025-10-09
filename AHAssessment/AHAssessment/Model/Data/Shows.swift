import Foundation

struct Shows: Decodable {
    let identifier: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

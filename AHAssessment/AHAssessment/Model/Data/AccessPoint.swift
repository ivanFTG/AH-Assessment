import Foundation

struct AccessPoint: Decodable {
    let identifier: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

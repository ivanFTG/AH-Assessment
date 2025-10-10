import Foundation

struct DigitallyShownBy: Decodable {
    let identifier: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

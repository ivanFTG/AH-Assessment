import Foundation

enum Measurement: String, Decodable {
    case width = "https://id.rijksmuseum.nl/22012"
    case height = "https://id.rijksmuseum.nl/22011"
    case unknown

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Measurement(rawValue: rawValue) ?? .unknown
    }
}

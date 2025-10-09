import Foundation

enum IdentifierType: String, Decodable {
    case identifier = "Identifier"
    case name = "Name"
    case unknown

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = IdentifierType(rawValue: rawValue) ?? .unknown
    }
}

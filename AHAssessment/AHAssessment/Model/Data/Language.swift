import Foundation

enum LanguageId: String, Decodable {
    case english = "http://vocab.getty.edu/aat/300388277"
    case dutch = "http://vocab.getty.edu/aat/300388256"
    case unknown

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = LanguageId(rawValue: rawValue) ?? .unknown
    }
}

struct ContentLanguage: Decodable {
    let identifier: LanguageId

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

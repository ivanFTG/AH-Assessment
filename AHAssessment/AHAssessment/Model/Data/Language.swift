import Foundation

enum LanguageId: String, Decodable {
    case english = "http://vocab.getty.edu/aat/300388277"
    case dutch = "http://vocab.getty.edu/aat/300388256"
}

struct ContentLanguage: Decodable {
    let identifier: LanguageId

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

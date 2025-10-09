import Foundation

struct CurrentLocation: Decodable {
    let identifiedBy: [IdentifiedBy]?
}

struct IdentifiedBy: Decodable {
    let type: IdentifierType?
    let content: String?
    let part: [LocationPart]?
    let language: ContentLanguage?
}

struct LocationPart: Decodable {
    let content: String?
}

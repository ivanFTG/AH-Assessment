import Foundation

struct CurrentLocation: Decodable {
    let identifiedBy: [IdentifiedBy]?
}

struct IdentifiedBy: Decodable {
    let type: IdentifierType?
    let content: String?
    let part: [LocationPart]?
    let language: [ContentLanguage]?

    var isEnglish: Bool {
        language?.contains { $0.identifier == .english } == true
    }
}

struct LocationPart: Decodable {
    let content: String?
}

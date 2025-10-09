import Foundation

struct Production: Decodable {
    let timeStamp: TimeStamp?
    let referredToBy: [ProductionReferredToBy]?
}

struct TimeStamp: Decodable {
    let identifiedBy: [IdentifiedBy]?

    enum CodingKeys: String, CodingKey {
        case identifiedBy = "identified_by"
    }

    struct IdentifiedBy: Decodable {
        let content: String?
        let language: ContentLanguage?
    }
}

struct ProductionReferredToBy: Decodable {
    let content: String?
    let language: ContentLanguage?
}

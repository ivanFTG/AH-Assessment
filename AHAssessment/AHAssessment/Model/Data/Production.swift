import Foundation

struct Production: Decodable {
    let timespan: Timespan?
    let referredToBy: [ProductionReferredToBy]?

    enum CodingKeys: String, CodingKey {
        case timespan
        case referredToBy = "referred_to_by"
    }
}

struct Timespan: Decodable {
    let identifiedBy: [IdentifiedBy]?

    enum CodingKeys: String, CodingKey {
        case identifiedBy = "identified_by"
    }

    struct IdentifiedBy: Decodable {
        let content: String?
        let language: [ContentLanguage]?

        var isEnglish: Bool {
            language?.contains { $0.identifier == .english } == true
        }
    }
}

struct ProductionReferredToBy: Decodable {
    let content: String?
    let language: [ContentLanguage]?

    var isEnglish: Bool {
        language?.contains { $0.identifier == .english } == true
    }
}

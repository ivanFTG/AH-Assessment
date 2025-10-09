import Foundation

struct SubjectOf: Decodable {
    let part: [Part]?
    let language: [ContentLanguage]?

    var isEnglish: Bool {
        language?.contains { $0.identifier == .english } == true
    }
}

struct Part: Decodable {
    let content: String?
    let part: [PartContent]?
}

struct PartContent: Decodable {
    let identifier: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case content
    }
}

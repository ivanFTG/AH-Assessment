import Foundation

struct Dimension: Decodable {
    let classifiedAs: ClassifiedAs?
    let value: String?

    enum CodingKeys: String, CodingKey {
        case classifiedAs = "classified_as"
        case value
    }
}

struct ClassifiedAs: Decodable {
    let identifier: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

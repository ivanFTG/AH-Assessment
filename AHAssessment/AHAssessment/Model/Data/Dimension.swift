import Foundation

struct Dimension: Decodable {
    let classifiedAs: [ClassifiedAs]?
    let value: String?

    var height: String? {
        guard classifiedAs?.contains(where: { $0.identifier == .height }) == true else {
            return nil
        }
        return value
    }

    var width: String? {
        guard classifiedAs?.contains(where: { $0.identifier == .width }) == true else {
            return nil
        }
        return value
    }

    enum CodingKeys: String, CodingKey {
        case classifiedAs = "classified_as"
        case value
    }
}

struct ClassifiedAs: Decodable {
    let identifier: Measurement

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

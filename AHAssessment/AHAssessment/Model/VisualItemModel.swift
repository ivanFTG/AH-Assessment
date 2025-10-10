import Foundation

struct VisualItemModel: Decodable {
    let idUrl: String?

    enum CodingKeys: String, CodingKey {
        case digitallyShownBy = "digitally_shown_by"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let digitallyShownBy = try container.decodeIfPresent([DigitallyShownBy].self, forKey: .digitallyShownBy)
        idUrl = digitallyShownBy?.first?.identifier
    }
}

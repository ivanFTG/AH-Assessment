import Foundation

struct ImageModel: Decodable {
    let url: String?

    enum CodingKeys: String, CodingKey {
        case accessPoint = "access_point"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let accessPoint = try container.decodeIfPresent([AccessPoint].self, forKey: .accessPoint)
        url = accessPoint?.first?.identifier
    }
}

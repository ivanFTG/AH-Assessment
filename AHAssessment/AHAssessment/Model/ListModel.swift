import Foundation

struct ListModel: Decodable {
    let nextPageUrl: String?
    let itemUrls: [String]

    enum CodingKeys: String, CodingKey {
        case next
        case orderedItems
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let nextPage = try container.decodeIfPresent(NextPage.self, forKey: .next)
        nextPageUrl = nextPage?.id

        let orderedItems = try container.decode([OrderedItem].self, forKey: .orderedItems)
        itemUrls = orderedItems.map(\.id)
    }

    init(nextPageUrl: String?, itemUrls: [String]) {
        self.nextPageUrl = nextPageUrl
        self.itemUrls = itemUrls
    }

    private struct NextPage: Decodable {
        let id: String
    }

    private struct OrderedItem: Decodable {
        let id: String
    }
}

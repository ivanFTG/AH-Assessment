import Foundation

struct DetailModel: Decodable {
    let identifier: String
    let date: String
    let author: String
    let briefTitle: String
    let briefSubtitle: String
    let briefDescription: String
    let height: String?
    let width: String?
    let locationCode: String?
    let locationDescription: String?
    let description: String?
    let imageDataUrls: [String]?

    var dimensions: String? {
        guard let height, let width else { return nil }
        return "\(height) x \(width)"
    }

    var location: String? {
        guard let locationCode, let locationDescription else { return nil }
        return "\(locationCode): \(locationDescription)"
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case producedBy = "produced_by"
        case subjectOf = "subject_of"
        case dimension
        case currentLocation = "current_location"
        case referredToBy = "referred_to_by"
        case shows
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)

        let production = try container.decodeIfPresent(Production.self, forKey: .producedBy)
        date = production?.timespan?.identifiedBy?
            .first { $0.isEnglish }?.content ?? "Unknown"
        author = production?.referredToBy?
            .first { $0.isEnglish }?.content ?? "Unknown"

        let subjectOf = try container.decodeIfPresent([SubjectOf].self, forKey: .subjectOf)
        let englishSubject = subjectOf?.first { $0.isEnglish }
        briefTitle = englishSubject?.part?
            .first { $0.part != nil }?.part?
            .first { $0.identifier != nil }?.content ?? "No Title Found"
        briefSubtitle = englishSubject?.part?
            .first { $0.part != nil }?.part?
            .first { $0.identifier == nil }?.content ?? "No Subtitle Found"
        briefDescription = englishSubject?.part?
            .first { $0.content != nil }?.content ?? "No Description Found"

        let dimension = try container.decodeIfPresent([Dimension].self, forKey: .dimension)
        height = dimension?.compactMap { $0.height }.first
        width = dimension?.compactMap { $0.width }.first

        let currentLocation = try container.decodeIfPresent(CurrentLocation.self, forKey: .currentLocation)
        locationCode = currentLocation?.identifiedBy?.first { $0.type == .identifier }?.content
        let englishLocationDescriptions = currentLocation?.identifiedBy?.filter {
            $0.type == .name && $0.isEnglish
        }.first
        locationDescription = englishLocationDescriptions?.part?.compactMap { $0.content }.joined(separator: ", ")

        let referredToBy = try container.decodeIfPresent([ReferredToBy].self, forKey: .referredToBy)
        let englishDescriptions = referredToBy?.filter { $0.isEnglish }
        description = englishDescriptions?.compactMap { $0.content }.joined(separator: "\n")

        let shows = try container.decodeIfPresent([Shows].self, forKey: .shows)
        imageDataUrls = shows?.map { $0.identifier }
    }

    init(
        identifier: String,
        date: String,
        author: String,
        briefTitle: String,
        briefSubtitle: String,
        briefDescription: String,
        height: String?,
        width: String?,
        locationCode: String?,
        locationDescription: String?,
        description: String?,
        imageDataUrls: [String]?
    ) {
        self.identifier = identifier
        self.date = date
        self.author = author
        self.briefTitle = briefTitle
        self.briefSubtitle = briefSubtitle
        self.briefDescription = briefDescription
        self.height = height
        self.width = width
        self.locationCode = locationCode
        self.locationDescription = locationDescription
        self.description = description
        self.imageDataUrls = imageDataUrls
    }
}

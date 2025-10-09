import Foundation

struct DetailModel: Decodable {
    let identifier: String
    let date: String?
    let author: String?
    let briefTitle: String?
    let briefSubtitle: String?
    let briefDescription: String?
    let height: String?
    let width: String?
    let locationCode: String?
    let locationDescription: String?
    let description: String?
    let imageDataUrls: [String]?

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
        date = production?.timeStamp?.identifiedBy?.first { $0.language?.identifier == .english }?.content
        author = production?.referredToBy?.first { $0.language?.identifier == .english }?.content

        let subjectOf = try container.decodeIfPresent([SubjectOf].self, forKey: .subjectOf)
        let englishSubject = subjectOf?.first { $0.isEnglish() }
        briefTitle = englishSubject?.part?.first { $0.part != nil }?.part?.first { $0.identifier != nil }?.content
        briefSubtitle = englishSubject?.part?.first { $0.part != nil }?.part?.first { $0.identifier == nil }?.content
        briefDescription = englishSubject?.part?.first { $0.content != nil }?.content

        let dimension = try container.decodeIfPresent([Dimension].self, forKey: .dimension)
        height = dimension?.first { $0.classifiedAs?.identifier == Measurement.height.rawValue }?.value
        width = dimension?.first { $0.classifiedAs?.identifier == Measurement.width.rawValue }?.value

        let currentLocation = try container.decodeIfPresent(CurrentLocation.self, forKey: .currentLocation)
        locationCode = currentLocation?.identifiedBy?.first { $0.type == .identifier }?.content
        let englishLocationDescriptions = currentLocation?.identifiedBy?.filter {
            $0.type == .name && $0.language?.identifier == .english
        }.first
        locationDescription = englishLocationDescriptions?.part?.compactMap { $0.content }.joined(separator: ", ")

        let referredToBuy = try container.decodeIfPresent([ReferredToBy].self, forKey: .referredToBy)
        let englishDescriptions = referredToBuy?.filter { $0.language?.identifier == .english }
        description = englishDescriptions?.compactMap { $0.content }.joined(separator: ", ")

        let shows = try container.decodeIfPresent([Shows].self, forKey: .shows)
        imageDataUrls = shows?.map { $0.identifier }
    }
}

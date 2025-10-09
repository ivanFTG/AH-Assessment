import Foundation

struct ReferredToBy: Decodable {
    let content: String?
    let language: [ContentLanguage]?

    var isEnglish: Bool {
        language?.contains { $0.identifier == .english } == true
    }
}

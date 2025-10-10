import Foundation

extension String {
    static func placeHolder(for numberOfCharacters: Int) -> String {
        String(repeating: " ", count: numberOfCharacters)
    }
}

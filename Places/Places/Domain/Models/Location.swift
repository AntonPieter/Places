import Foundation

struct Location: Codable, Identifiable, Equatable, Sendable {
    let name: String?
    let lat: Double
    let long: Double

    var id: String {
        "\(lat),\(long)"
    }

    var displayName: String {
        name ?? String(localized: "unknown_location")
    }
}

struct LocationsResponse: Codable, Sendable {
    let locations: [Location]
}

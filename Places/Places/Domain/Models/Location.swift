import Foundation

struct Location: Codable, Identifiable, Equatable, Sendable {
    let name: String?
    let lat: Double
    let long: Double
    let isCustom: Bool

    init(name: String?, lat: Double, long: Double, isCustom: Bool = false) {
        self.name = name
        self.lat = lat
        self.long = long
        self.isCustom = isCustom
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        lat = try container.decode(Double.self, forKey: .lat)
        long = try container.decode(Double.self, forKey: .long)
        isCustom = try container.decodeIfPresent(Bool.self, forKey: .isCustom) ?? false
    }

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

import Testing
import Foundation
@testable import Places

@MainActor
struct LocationTests {

    @Test func decodesLocationWithName() throws {
        let json = """
        {"name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215}
        """.data(using: .utf8)!

        let location = try JSONDecoder().decode(Location.self, from: json)
        #expect(location.name == "Amsterdam")
        #expect(location.lat == 52.3547498)
        #expect(location.long == 4.8339215)
    }

    @Test func decodesLocationWithoutName() throws {
        let json = """
        {"lat": 40.4380638, "long": -3.7495758}
        """.data(using: .utf8)!

        let location = try JSONDecoder().decode(Location.self, from: json)
        #expect(location.name == nil)
    }

    @Test func decodesLocationsResponse() throws {
        let json = """
        {"locations": [{"name": "Amsterdam", "lat": 52.35, "long": 4.83}]}
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(LocationsResponse.self, from: json)
        #expect(response.locations.count == 1)
        #expect(response.locations.first?.name == "Amsterdam")
    }

    @Test func displayNameWithName() {
        let location = Location(name: "Amsterdam", lat: 52.35, long: 4.83)
        #expect(location.displayName == "Amsterdam")
    }

    @Test func displayNameWithoutName() {
        let location = Location(name: nil, lat: 40.4381, long: -3.7496)
        #expect(location.displayName == String(localized: "unknown_location"))
    }

    @Test func locationId() {
        let location = Location(name: "Test", lat: 1.0, long: 2.0)
        #expect(location.id == "1.0,2.0")
    }

    // MARK: - isCustom

    @Test func isCustom_givenDefault_returnsFalse() {
        let location = Location(name: "Amsterdam", lat: 52.35, long: 4.83)
        #expect(location.isCustom == false)
    }

    @Test func isCustom_givenTrue_returnsTrue() {
        let location = Location(name: "Rotterdam", lat: 51.92, long: 4.48, isCustom: true)
        #expect(location.isCustom == true)
    }

    @Test func decodesLocation_givenNoIsCustomField_defaultsToFalse() throws {
        // Given - JSON without isCustom (like API responses)
        let json = """
        {"name": "Amsterdam", "lat": 52.35, "long": 4.83}
        """.data(using: .utf8)!

        // When
        let location = try JSONDecoder().decode(Location.self, from: json)

        // Then
        #expect(location.isCustom == false)
    }

    @Test func decodesLocation_givenIsCustomField_preservesValue() throws {
        // Given - JSON with isCustom (like stored custom locations)
        let json = """
        {"name": "Rotterdam", "lat": 51.92, "long": 4.48, "isCustom": true}
        """.data(using: .utf8)!

        // When
        let location = try JSONDecoder().decode(Location.self, from: json)

        // Then
        #expect(location.isCustom == true)
    }
}

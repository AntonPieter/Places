import Testing
import Foundation
@testable import Places

@MainActor
struct LocationRepositoryTests {

    @Test func fetchLocationsReturnsLocations() async throws {
        let mockClient = MockAPIClient()
        mockClient.result = LocationsResponse(locations: [
            Location(name: "Amsterdam", lat: 52.35, long: 4.83)
        ])

        let repository = LocationRepository(apiClient: mockClient)
        let locations = try await repository.fetchLocations()

        #expect(locations.count == 1)
        #expect(locations.first?.name == "Amsterdam")
    }

    @Test func fetchLocationsThrowsOnError() async {
        let mockClient = MockAPIClient()
        mockClient.error = APIError.invalidResponse

        let repository = LocationRepository(apiClient: mockClient)

        await #expect(throws: APIError.self) {
            try await repository.fetchLocations()
        }
    }
}

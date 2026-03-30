import Foundation
@testable import Places

final class MockLocationRepository: LocationRepositoryProtocol {
    var locations: [Location] = []
    var error: Error?

    func fetchLocations() async throws -> [Location] {
        if let error { throw error }
        return locations
    }
}

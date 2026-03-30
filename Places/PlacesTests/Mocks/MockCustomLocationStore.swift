import Foundation
@testable import Places

final class MockCustomLocationStore: CustomLocationStoreProtocol {
    var storedLocations: [Location] = []

    func load() -> [Location] {
        storedLocations
    }

    func save(_ locations: [Location]) {
        storedLocations = locations
    }
}

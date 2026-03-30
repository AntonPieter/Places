import Foundation
@testable import Places

final class MockGeocodingService: GeocodingServiceProtocol {
    var reverseGeocodeResult: String?
    var reverseGeocodeError: Error?

    func reverseGeocode(latitude: Double, longitude: Double) async throws -> String {
        if let reverseGeocodeError {
            throw reverseGeocodeError
        }

        guard let reverseGeocodeResult else {
            throw GeocodingError.cityNotFound
        }

        return reverseGeocodeResult
    }
}

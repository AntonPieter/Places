import Foundation
import MapKit

protocol GeocodingServiceProtocol {
    func reverseGeocode(latitude: Double, longitude: Double) async throws -> String
}

enum GeocodingError: LocalizedError, Sendable {
    case cityNotFound

    var errorDescription: String? {
        switch self {
        case .cityNotFound:
            return String(localized: "error_city_not_found")
        }
    }
}

final class GeocodingService: GeocodingServiceProtocol {
    func reverseGeocode(latitude: Double, longitude: Double) async throws -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        guard let request = MKReverseGeocodingRequest(location: location) else {
            throw GeocodingError.cityNotFound
        }

        let mapItems = try await request.mapItems

        guard let cityName = mapItems.first?.addressRepresentations?.cityName else {
            throw GeocodingError.cityNotFound
        }

        return cityName
    }
}

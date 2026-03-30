import Foundation
@testable import Places

@MainActor
final class MockCitySearchService: CitySearchServiceProtocol {
    var onSuggestionsUpdated: (([CitySuggestion]) -> Void)?

    var stubbedSuggestions: [CitySuggestion] = []
    var stubbedLocation: Location?
    var stubbedError: Error?
    var updatedQueries: [String] = []
    var resolvedSuggestionIds: [String] = []

    func updateQuery(_ query: String) {
        updatedQueries.append(query)
        onSuggestionsUpdated?(stubbedSuggestions)
    }

    func resolveLocation(for suggestion: CitySuggestion) async throws -> Location {
        resolvedSuggestionIds.append(suggestion.id)

        if let error = stubbedError {
            throw error
        }

        guard let location = stubbedLocation else {
            throw GeocodingError.cityNotFound
        }

        return location
    }
}

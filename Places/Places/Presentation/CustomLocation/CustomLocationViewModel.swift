import Foundation
import Observation

@MainActor
@Observable
final class CustomLocationViewModel {
    var searchText = ""  {
        didSet { queryChanged() }
    }
    var suggestions: [CitySuggestion] = []
    var isResolving = false
    var errorMessage: String?

    private let searchService: CitySearchServiceProtocol

    init(searchService: CitySearchServiceProtocol? = nil) {
        let service = searchService ?? CitySearchService()
        self.searchService = service
        service.onSuggestionsUpdated = { suggestions in
            self.suggestions = suggestions
            self.errorMessage = nil
        }
    }

    func selectSuggestion(_ suggestion: CitySuggestion) async -> Location? {
        isResolving = true
        errorMessage = nil

        do {
            let location = try await searchService.resolveLocation(for: suggestion)
            isResolving = false
            return location
        } catch {
            errorMessage = String(localized: "error_city_not_found")
            isResolving = false
            return nil
        }
    }

    private func queryChanged() {
        searchService.updateQuery(searchText)
    }
}

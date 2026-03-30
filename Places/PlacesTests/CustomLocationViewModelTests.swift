import Testing
import Foundation
@testable import Places

@MainActor
struct CustomLocationViewModelTests {

    private func makeSuggestion(title: String = "Amsterdam", subtitle: String = "Netherlands") -> CitySuggestion {
        CitySuggestion(id: "\(title)|\(subtitle)", title: title, subtitle: subtitle)
    }

    // MARK: - Query Updates

    @Test func queryUpdate_givenTwoOrMoreCharacters_updatesService() {
        // Given
        let mock = MockCitySearchService()
        let viewModel = CustomLocationViewModel(searchService: mock)

        // When
        viewModel.searchText = "Am"

        // Then
        #expect(mock.updatedQueries == ["Am"])
    }

    @Test func queryUpdate_givenSingleCharacter_stillForwardsToService() {
        // Given
        let mock = MockCitySearchService()
        let viewModel = CustomLocationViewModel(searchService: mock)

        // When
        viewModel.searchText = "A"

        // Then
        #expect(mock.updatedQueries == ["A"])
    }

    @Test func queryUpdate_givenEmptyText_forwardsToService() {
        // Given
        let mock = MockCitySearchService()
        let viewModel = CustomLocationViewModel(searchService: mock)

        // When
        viewModel.searchText = ""

        // Then
        #expect(mock.updatedQueries == [""])
    }

    // MARK: - Suggestions

    @Test func suggestions_givenServiceReturnsSuggestions_updatesViewModelSuggestions() {
        // Given
        let mock = MockCitySearchService()
        let suggestion = makeSuggestion()
        mock.stubbedSuggestions = [suggestion]
        let viewModel = CustomLocationViewModel(searchService: mock)

        // When
        viewModel.searchText = "Amst"

        // Then
        #expect(viewModel.suggestions.count == 1)
        #expect(viewModel.suggestions.first?.title == "Amsterdam")
    }

    // MARK: - Select Suggestion

    @Test func selectSuggestion_givenSuccessfulResolution_returnsLocation() async {
        // Given
        let mock = MockCitySearchService()
        mock.stubbedLocation = Location(name: "Amsterdam", lat: 52.3676, long: 4.9041)
        let viewModel = CustomLocationViewModel(searchService: mock)
        let suggestion = makeSuggestion()

        // When
        let location = await viewModel.selectSuggestion(suggestion)

        // Then
        #expect(location?.name == "Amsterdam")
        #expect(location?.lat == 52.3676)
        #expect(location?.long == 4.9041)
        #expect(viewModel.isResolving == false)
        #expect(viewModel.errorMessage == nil)
        #expect(mock.resolvedSuggestionIds == [suggestion.id])
    }

    @Test func selectSuggestion_givenFailedResolution_returnsNilWithError() async {
        // Given
        let mock = MockCitySearchService()
        mock.stubbedError = GeocodingError.cityNotFound
        let viewModel = CustomLocationViewModel(searchService: mock)
        let suggestion = makeSuggestion()

        // When
        let location = await viewModel.selectSuggestion(suggestion)

        // Then
        #expect(location == nil)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isResolving == false)
    }

    @Test func selectSuggestion_givenSuccessfulResolution_clearsError() async {
        // Given
        let mock = MockCitySearchService()
        mock.stubbedError = GeocodingError.cityNotFound
        let viewModel = CustomLocationViewModel(searchService: mock)
        let suggestion = makeSuggestion()

        // First trigger an error
        _ = await viewModel.selectSuggestion(suggestion)
        #expect(viewModel.errorMessage != nil)

        // When - resolve successfully
        mock.stubbedError = nil
        mock.stubbedLocation = Location(name: "Amsterdam", lat: 52.3676, long: 4.9041)
        let location = await viewModel.selectSuggestion(suggestion)

        // Then
        #expect(location != nil)
        #expect(viewModel.errorMessage == nil)
    }
}

import Testing
import Foundation
@testable import Places

@MainActor
struct LocationListViewModelTests {

    @Test func loadLocationsSuccess() async {
        let mockRepo = MockLocationRepository()
        mockRepo.locations = [
            Location(name: "Amsterdam", lat: 52.35, long: 4.83),
            Location(name: "Mumbai", lat: 19.08, long: 72.81)
        ]
        let useCase = FetchLocationsUseCase(repository: mockRepo)
        let mockStore = MockCustomLocationStore()
        let mockGeocoding = MockGeocodingService()
        let viewModel = LocationListViewModel(fetchLocationsUseCase: useCase, customLocationStore: mockStore, geocodingService: mockGeocoding)

        await viewModel.loadLocations()

        #expect(viewModel.locations.count == 2)
        #expect(viewModel.locations.first?.name == "Amsterdam")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test func loadLocationsCombinesApiAndCustom() async {
        let mockRepo = MockLocationRepository()
        mockRepo.locations = [
            Location(name: "Amsterdam", lat: 52.35, long: 4.83)
        ]
        let useCase = FetchLocationsUseCase(repository: mockRepo)
        let mockStore = MockCustomLocationStore()
        mockStore.storedLocations = [
            Location(name: "Rotterdam", lat: 51.92, long: 4.48)
        ]
        let mockGeocoding = MockGeocodingService()
        let viewModel = LocationListViewModel(fetchLocationsUseCase: useCase, customLocationStore: mockStore, geocodingService: mockGeocoding)

        await viewModel.loadLocations()

        #expect(viewModel.locations.count == 2)
        #expect(viewModel.locations[0].name == "Amsterdam")
        #expect(viewModel.locations[1].name == "Rotterdam")
    }

    @Test func loadLocationsFailureStillShowsCustom() async {
        let mockRepo = MockLocationRepository()
        mockRepo.error = APIError.invalidResponse
        let useCase = FetchLocationsUseCase(repository: mockRepo)
        let mockStore = MockCustomLocationStore()
        mockStore.storedLocations = [
            Location(name: "Rotterdam", lat: 51.92, long: 4.48)
        ]
        let mockGeocoding = MockGeocodingService()
        let viewModel = LocationListViewModel(fetchLocationsUseCase: useCase, customLocationStore: mockStore, geocodingService: mockGeocoding)

        await viewModel.loadLocations()

        #expect(viewModel.locations.count == 1)
        #expect(viewModel.locations.first?.name == "Rotterdam")
        #expect(viewModel.errorMessage != nil)
    }

    @Test func openInWikipediaCallsUseCase() {
        let mockOpener = MockURLOpener()
        let openUseCase = OpenWikipediaUseCase(urlOpener: mockOpener)
        let viewModel = LocationListViewModel(openWikipediaUseCase: openUseCase)

        let location = Location(name: "Amsterdam", lat: 52.35, long: 4.83)
        viewModel.openInWikipedia(location: location)

        #expect(mockOpener.openedURLs.count == 1)
    }

    @Test func loadLocationsResolvesUnnamedLocations() async {
        let mockRepo = MockLocationRepository()
        mockRepo.locations = [
            Location(name: nil, lat: 40.44, long: -3.75)
        ]
        let useCase = FetchLocationsUseCase(repository: mockRepo)
        let mockStore = MockCustomLocationStore()
        let mockGeocoding = MockGeocodingService()
        mockGeocoding.reverseGeocodeResult = "Madrid"
        let viewModel = LocationListViewModel(fetchLocationsUseCase: useCase, customLocationStore: mockStore, geocodingService: mockGeocoding)

        await viewModel.loadLocations()

        #expect(viewModel.locations.first?.name == "Madrid")
    }

    @Test func loadLocationsKeepsUnknownWhenReverseGeocodeFails() async {
        let mockRepo = MockLocationRepository()
        mockRepo.locations = [
            Location(name: nil, lat: 0.0, long: 0.0)
        ]
        let useCase = FetchLocationsUseCase(repository: mockRepo)
        let mockStore = MockCustomLocationStore()
        let mockGeocoding = MockGeocodingService()
        mockGeocoding.reverseGeocodeError = GeocodingError.cityNotFound
        let viewModel = LocationListViewModel(fetchLocationsUseCase: useCase, customLocationStore: mockStore, geocodingService: mockGeocoding)

        await viewModel.loadLocations()

        #expect(viewModel.locations.first?.name == nil)
        #expect(viewModel.locations.first?.displayName == String(localized: "unknown_location"))
    }

    @Test func addLocationPersistsToStore() {
        let mockStore = MockCustomLocationStore()
        let viewModel = LocationListViewModel(customLocationStore: mockStore)
        let location = Location(name: "Rotterdam", lat: 51.9225, long: 4.4792)

        viewModel.addLocation(location)

        #expect(viewModel.locations.count == 1)
        #expect(viewModel.locations.first?.name == "Rotterdam")
        #expect(mockStore.storedLocations.count == 1)
        #expect(mockStore.storedLocations.first?.name == "Rotterdam")
    }
}

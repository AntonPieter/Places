import Foundation
import Observation

@MainActor
@Observable
final class LocationListViewModel {
    var locations: [Location] = []
    var isLoading = false
    var errorMessage: String?

    private let fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    private let openWikipediaUseCase: OpenWikipediaUseCaseProtocol
    private let customLocationStore: CustomLocationStoreProtocol
    private let geocodingService: GeocodingServiceProtocol

    init(
        fetchLocationsUseCase: FetchLocationsUseCaseProtocol? = nil,
        openWikipediaUseCase: OpenWikipediaUseCaseProtocol? = nil,
        customLocationStore: CustomLocationStoreProtocol? = nil,
        geocodingService: GeocodingServiceProtocol? = nil
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase ?? FetchLocationsUseCase()
        self.openWikipediaUseCase = openWikipediaUseCase ?? OpenWikipediaUseCase()
        self.customLocationStore = customLocationStore ?? CustomLocationStore()
        self.geocodingService = geocodingService ?? GeocodingService()
    }

    func loadLocations() async {
        isLoading = true
        errorMessage = nil

        do {
            let apiLocations = try await fetchLocationsUseCase.execute()
            let customLocations = customLocationStore.load()
            locations = apiLocations + customLocations
        } catch {
            errorMessage = error.localizedDescription
            locations = customLocationStore.load()
        }

        isLoading = false

        await resolveLocationNames()
    }

    func addLocation(_ location: Location) {
        locations.append(location)
        var customLocations = customLocationStore.load()
        customLocations.append(location)
        customLocationStore.save(customLocations)
    }

    func openInWikipedia(location: Location) {
        openWikipediaUseCase.execute(latitude: location.lat, longitude: location.long)
    }

    private func resolveLocationNames() async {
        for index in locations.indices where locations[index].name == nil {
            if let name = try? await geocodingService.reverseGeocode(
                latitude: locations[index].lat,
                longitude: locations[index].long
            ) {
                locations[index] = Location(name: name, lat: locations[index].lat, long: locations[index].long)
            }
        }
    }
}

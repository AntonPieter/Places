import Foundation

final class LocationRepository: LocationRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let locationsURL: URL?

    init(apiClient: APIClientProtocol = APIClient(), url: URL? = AppConfiguration.locationsURL) {
        self.apiClient = apiClient
        self.locationsURL = url
    }

    func fetchLocations() async throws -> [Location] {
        guard let locationsURL else {
            throw APIError.invalidURL
        }
        let response: LocationsResponse = try await apiClient.fetch(from: locationsURL)
        return response.locations
    }
}

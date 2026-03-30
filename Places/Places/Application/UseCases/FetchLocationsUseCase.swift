import Foundation

protocol FetchLocationsUseCaseProtocol {
    func execute() async throws -> [Location]
}

final class FetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    private let repository: LocationRepositoryProtocol

    init(repository: LocationRepositoryProtocol = LocationRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [Location] {
        try await repository.fetchLocations()
    }
}

import Foundation

protocol LocationRepositoryProtocol {
    func fetchLocations() async throws -> [Location]
}

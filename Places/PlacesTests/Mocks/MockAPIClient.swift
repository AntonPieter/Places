import Foundation
@testable import Places

final class MockAPIClient: APIClientProtocol {
    var result: Any?
    var error: Error?

    func fetch<T: Decodable>(from url: URL) async throws -> T {
        if let error { throw error }
        guard let result = result as? T else {
            throw APIError.invalidResponse
        }
        return result
    }
}

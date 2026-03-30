import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum APIError: LocalizedError, Sendable {
    case invalidResponse
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return String(localized: "error_invalid_response")
        case .invalidURL:
            return String(localized: "error_invalid_url")
        }
    }
}

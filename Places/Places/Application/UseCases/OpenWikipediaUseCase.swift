import Foundation

protocol URLOpening {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL)
}

protocol OpenWikipediaUseCaseProtocol {
    @discardableResult
    func execute(latitude: Double, longitude: Double) -> Bool
}

final class OpenWikipediaUseCase: OpenWikipediaUseCaseProtocol {
    private let urlOpener: URLOpening

    init(urlOpener: URLOpening = DefaultURLOpener()) {
        self.urlOpener = urlOpener
    }

    static func buildURL(latitude: Double, longitude: Double) -> URL? {
        URL(string: "\(AppConfiguration.wikipediaBaseURL)?lat=\(latitude)&lon=\(longitude)")
    }

    @discardableResult
    func execute(latitude: Double, longitude: Double) -> Bool {
        guard let url = Self.buildURL(latitude: latitude, longitude: longitude),
              urlOpener.canOpenURL(url) else {
            return false
        }
        urlOpener.open(url)
        return true
    }
}

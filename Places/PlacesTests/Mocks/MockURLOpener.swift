import Foundation
@testable import Places

final class MockURLOpener: URLOpening {
    var canOpen = true
    var openedURLs: [URL] = []

    func canOpenURL(_ url: URL) -> Bool {
        canOpen
    }

    func open(_ url: URL) {
        openedURLs.append(url)
    }
}

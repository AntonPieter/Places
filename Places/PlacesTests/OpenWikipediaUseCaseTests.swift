import Testing
import Foundation
@testable import Places

struct OpenWikipediaUseCaseTests {

    @Test func buildURLCreatesCorrectURL() {
        let url = OpenWikipediaUseCase.buildURL(latitude: 52.3676, longitude: 4.9041)
        #expect(url?.absoluteString == "wikipedia://places?lat=52.3676&lon=4.9041")
    }

    @Test func executeOpensURL() {
        let mockOpener = MockURLOpener()
        let useCase = OpenWikipediaUseCase(urlOpener: mockOpener)

        let result = useCase.execute(latitude: 52.3676, longitude: 4.9041)

        #expect(result == true)
        #expect(mockOpener.openedURLs.count == 1)
        #expect(mockOpener.openedURLs.first?.absoluteString == "wikipedia://places?lat=52.3676&lon=4.9041")
    }

    @Test func executeReturnsFalseWhenCannotOpen() {
        let mockOpener = MockURLOpener()
        mockOpener.canOpen = false
        let useCase = OpenWikipediaUseCase(urlOpener: mockOpener)

        let result = useCase.execute(latitude: 52.3676, longitude: 4.9041)

        #expect(result == false)
        #expect(mockOpener.openedURLs.isEmpty)
    }
}

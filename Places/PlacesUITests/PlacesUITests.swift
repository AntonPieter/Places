import XCTest

final class PlacesUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
    }

    // MARK: - Location List

    @MainActor
    func testLocationListShowsTitle() {
        XCTAssertTrue(app.navigationBars["Places"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLocationListShowsAddButton() {
        let addButton = app.navigationBars.buttons["Add custom location"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
    }

    // MARK: - Custom Location Sheet

    @MainActor
    func testAddButtonOpensCustomLocationSheet() {
        let addButton = app.navigationBars.buttons["Add custom location"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let sheetTitle = app.navigationBars["Custom Location"]
        XCTAssertTrue(sheetTitle.waitForExistence(timeout: 3))
    }

    @MainActor
    func testCancelDismissesCustomLocationSheet() {
        let addButton = app.navigationBars.buttons["Add custom location"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 3))
        cancelButton.tap()

        let sheetTitle = app.navigationBars["Custom Location"]
        XCTAssertFalse(sheetTitle.waitForExistence(timeout: 2))
    }

    @MainActor
    func testCustomLocationSheetHasSearchField() {
        let addButton = app.navigationBars.buttons["Add custom location"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let searchField = app.textFields["E.g. Amsterdam"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
    }

    @MainActor
    func testSearchFieldAcceptsInput() {
        let addButton = app.navigationBars.buttons["Add custom location"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let searchField = app.textFields["E.g. Amsterdam"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.tap()
        searchField.typeText("Amsterdam")

        XCTAssertEqual(searchField.value as? String, "Amsterdam")
    }
}
